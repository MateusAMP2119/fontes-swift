//
//  FeedStore.swift
//  fontes
//
//  Created by Mateus Costa on 10/01/2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class FeedStore: ObservableObject {
    static let shared = FeedStore()
    
    @Published var items: [ReadingItem] = []
    @Published var isLoading = false
    @Published var isInitialLoading = true
    @Published var imagesPreloaded = false
    @Published var error: Error?
    @Published var lastUpdated: Date?
    @Published var isOfflineMode = false
    @Published var dataSource: DataSource = .none
    @Published var lastReadItem: ReadingItem?
    
    enum DataSource {
        case none
        case network
        case cache
    }
    
    private let service = RSSFeedService.shared
    private let localStorage = LocalStorageService.shared
    private let networkMonitor = NetworkMonitor.shared
    private let imageCache = ImageCacheService.shared
    
    @Published var feeds: [RSSFeed] = []
    
    // Cache duration in seconds (5 minutes for network, 24 hours max for offline)
    private let cacheDuration: TimeInterval = 300
    private let maxCacheAge: TimeInterval = 86400 // 24 hours
    
    // Number of images to preload for initial display
    private let preloadImageCount = 10
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupNetworkMonitoring()
        Task {
            await loadConfiguration()
        }
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isOfflineMode = !isConnected
                // If we just came back online and have no items, try to fetch
                if isConnected && self?.items.isEmpty == true {
                    Task {
                        await self?.loadFeeds(forceRefresh: true)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    var featuredItem: ReadingItem? {
        items.first
    }
    
    var gridItems: [ReadingItem] {
        Array(items.dropFirst())
    }
    
    // Available sources for filtering
    var availableSources: [String] {
        Array(Set(items.map { $0.source })).sorted()
    }
    
    // Available tags for filtering
    var availableTags: [String] {
        Array(Set(items.flatMap { $0.tags })).sorted()
    }
    
    // Available authors for filtering
    var availableAuthors: [String] {
        Array(Set(items.map { $0.author })).sorted()
    }
    
    func loadFeeds(forceRefresh: Bool = false) async {
        // Skip if recently loaded and not forcing refresh
        if !forceRefresh,
           let lastUpdated = lastUpdated,
           Date().timeIntervalSince(lastUpdated) < cacheDuration,
           !items.isEmpty {
            return
        }
        
        isLoading = true
        error = nil
        
        // Check if we're offline
        if !networkMonitor.isConnected {
            await loadFromCache()
            return
        }
        
        // Ensure configuration is loaded before fetching
        if feeds.isEmpty {
            await loadConfiguration()
        }
        
        // Try to fetch from network
        let activeFeeds = feeds.filter { $0.isEnabled }
        let results = await service.fetchAllFeeds(activeFeeds)
        
        // If network fetch failed or returned empty, try cache
        if results.isEmpty {
            await loadFromCache()
            return
        }
        
        // Convert RSS items to ReadingItems and merge from all feeds
        var allItems: [ReadingItem] = []
        
        for (feed, rssItems) in results {
            let readingItems = rssItems.map { ReadingItem.from(rssItem: $0, feed: feed) }
            allItems.append(contentsOf: readingItems)
        }
        
        // Sort by date (newest first)
        allItems.sort { item1, item2 in
            guard let date1 = item1.publishedDate else { return false }
            guard let date2 = item2.publishedDate else { return true }
            return date1 > date2
        }
        
        // Remove duplicates based on title similarity
        allItems = removeDuplicates(from: allItems)
        
        self.items = allItems
        self.lastUpdated = Date()
        self.dataSource = .network
        
        // Preload images for first items before hiding splash screen
        await preloadInitialImages(for: allItems)
        
        self.isLoading = false
        self.isInitialLoading = false
        
        // Save to local storage for offline access
        Task {
            try? await localStorage.saveFeedItems(allItems)
        }
        
        if allItems.isEmpty {
            self.error = RSSError.parsingFailed
        }
    }
    
    /// Preload images for initial display
    private func preloadInitialImages(for items: [ReadingItem]) async {
        await imageCache.preloadImages(for: items, limit: preloadImageCount)
        self.imagesPreloaded = true
    }
    
    /// Load items from local cache
    private func loadFromCache() async {
        do {
            let cachedItems = try await localStorage.loadFeedItems()
            if !cachedItems.isEmpty {
                self.items = cachedItems
                self.dataSource = .cache
                
                // Get cache metadata for last updated time
                if let metadata = await localStorage.getCacheMetadata() {
                    self.lastUpdated = metadata.lastUpdated
                }
                
                // Preload images for cached items
                await preloadInitialImages(for: cachedItems)
            } else {
                self.error = LocalStorageError.fileNotFound
            }
        } catch {
            self.error = error
        }
        
        self.isLoading = false
        self.isInitialLoading = false
    }
    
    /// Preload cached data on app launch
    func preloadCachedData() async {
        // Load from cache first for instant display
        if let cachedItems = try? await localStorage.loadFeedItems(), !cachedItems.isEmpty {
            self.items = cachedItems
            self.dataSource = .cache
            
            // Preload images for cached items
            await preloadInitialImages(for: cachedItems)
            
            self.isInitialLoading = false
            
            if let metadata = await localStorage.getCacheMetadata() {
                self.lastUpdated = metadata.lastUpdated
            }
        }
    }
    
    func refresh() async {
        // If offline, show error but still try to load from cache
        if !networkMonitor.isConnected {
            await loadFromCache()
            return
        }
        await loadFeeds(forceRefresh: true)
    }
    
    /// Clear the local cache
    func clearCache() async {
        try? await localStorage.clearCache()
    }
    
    /// Status message for UI
    var statusMessage: String? {
        if isOfflineMode && dataSource == .cache {
            if let lastUpdated = lastUpdated {
                let formatter = RelativeDateTimeFormatter()
                formatter.unitsStyle = .abbreviated
                let relativeTime = formatter.localizedString(for: lastUpdated, relativeTo: Date())
                return "Offline • Updated \(relativeTime)"
            }
            return "Offline • Showing cached articles"
        }
        return nil
    }
    
    // Filter items based on selected criteria
    func filteredItems(
        tags: Set<String>,
        journalists: Set<String>,
        sources: Set<String>
    ) -> (featured: ReadingItem?, list: [ReadingItem]) {
        let filtered: [ReadingItem]
        
        if tags.isEmpty && journalists.isEmpty && sources.isEmpty {
            filtered = items
        } else {
            filtered = items.filter { item in
                let matchesTags = tags.isEmpty || !tags.isDisjoint(with: Set(item.tags))
                let matchesJournalist = journalists.isEmpty || journalists.contains(item.author)
                let matchesSource = sources.isEmpty || sources.contains(item.source)
                
                return matchesTags && matchesJournalist && matchesSource
            }
        }
        
        if let first = filtered.first {
            return (first, Array(filtered.dropFirst()))
        } else {
            return (nil, [])
        }
    }
    
    private func removeDuplicates(from items: [ReadingItem]) -> [ReadingItem] {
        var seen = Set<String>()
        return items.filter { item in
            // Normalize title for comparison
            let normalizedTitle = item.title
                .lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if seen.contains(normalizedTitle) {
                return false
            }
            seen.insert(normalizedTitle)
            return true
        }
    }
    
    func updateLastRead(item: ReadingItem) {
        lastReadItem = item
    }
    
    // MARK: - Configuration Management
    
    private func loadConfiguration() async {
        do {
            let config = try await localStorage.loadFeedConfig()
            if !config.isEmpty {
                self.feeds = config
            } else {
                self.feeds = RSSFeed.defaultFeeds
                try? await localStorage.saveFeedConfig(self.feeds)
            }
        } catch {
            print("Failed to load feed configuration: \(error)")
            self.feeds = RSSFeed.defaultFeeds
        }
    }
    
    func updateFeeds(_ newFeeds: [RSSFeed]) {
        self.feeds = newFeeds
        Task {
            try? await localStorage.saveFeedConfig(newFeeds)
            await loadFeeds(forceRefresh: true)
        }
    }
    
    func toggleFeedInternal(_ feed: RSSFeed) {
         // Logic to toggle feed active/inactive if we had that state.
         // For now, if we remove it from the list, it's gone.
         // But maybe we want to keep it but mark inactive.
         // The requirement says "edit this", so removing/adding is fine.
    }
}

