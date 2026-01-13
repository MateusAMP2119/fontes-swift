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
    
    // Available RSS Feeds from the service (configuration)
    @Published var rssFeeds: [RSSFeed] = []
    
    // User-created Feeds (Smart Feeds)
    @Published var userFeeds: [Feed] = []
    
    // Active User Feeds (IDs)
    @Published var activeFeedIDs: Set<UUID> = []
    
    // Cache duration in seconds (5 minutes for network, 24 hours max for offline)
    private let cacheDuration: TimeInterval = 300
    private let maxCacheAge: TimeInterval = 86400 // 24 hours
    
    // Number of images to preload for initial display
    private let preloadImageCount = 30
    
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
        if rssFeeds.isEmpty {
            await loadConfiguration()
        }
        
        // Try to fetch from network. We always fetch all enabled RSS feeds to have the data available.
        // Optimization: In a real app, we might only fetch RSS feeds required by active User Feeds.
        // For now, based on "Base feed contains all", we fetch everything enabled in RSS config.
        let activeRSSFeeds = rssFeeds.filter { $0.isEnabled }
        let results = await service.fetchAllFeeds(activeRSSFeeds)
        
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
    /// Preload images for initial display
    private func preloadInitialImages(for items: [ReadingItem]) async {
        print("Starting preloading for ALL \(items.count) items")
        let start = Date()
        // Pass a large limit to cover all items
        await imageCache.preloadImages(for: items, limit: items.count)
        print("Finished preloading in \(Date().timeIntervalSince(start))s")
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
    
    // Filter items based on active User Feeds
    var currentDisplayItems: (featured: ReadingItem?, list: [ReadingItem]) {
        // If no user feeds are active, decided to show Base Feed (All) or nothing.
        // Plan says: "If activeFeedIDs is empty, fallback to Base Feed"
        
        let effectiveFeedIDs: Set<UUID> = activeFeedIDs
        
        let activeFeeds = userFeeds.filter { effectiveFeedIDs.contains($0.id) }
        
        // Filter items: Union of all active feeds
        // An item is included if it matches ANY of the active feeds
        let filtered = items.filter { item in
            activeFeeds.contains { feed in
                feed.matches(item)
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
    
    // MARK: - Configuration Management
    
    private func loadConfiguration() async {
        do {
            // Load RSS Config (Sources)
            let rssConfig = try await localStorage.loadFeedConfig()
            if !rssConfig.isEmpty {
                self.rssFeeds = rssConfig
            } else {
                self.rssFeeds = RSSFeed.defaultFeeds
                try? await localStorage.saveFeedConfig(self.rssFeeds)
            }
            
            // Load User Feeds
            var loadedUserFeeds = try await localStorage.loadUserFeeds()
            
            // Migration: Rename "All Sources" to "Para ti"
            if let index = loadedUserFeeds.firstIndex(where: { $0.isDefault && $0.name == "All Sources" }) {
                loadedUserFeeds[index].name = "Para ti"
                try? await localStorage.saveUserFeeds(loadedUserFeeds)
            }
            
            if !loadedUserFeeds.isEmpty {
                self.userFeeds = loadedUserFeeds
            } else {
                self.userFeeds = [Feed.defaultFeed]
                try? await localStorage.saveUserFeeds(self.userFeeds)
            }
            
            // Default to "All Sources" (Default Feed) if no active feeds are set (initial launch)
            // If we add persistence for activeFeedIDs later, we should load it here.
            if self.activeFeedIDs.isEmpty {
                 if let defaultFeed = self.userFeeds.first(where: { $0.isDefault }) {
                     self.activeFeedIDs = [defaultFeed.id]
                 }
            }
            
            // Load Active Feeds State (Optional: could persist this too)
            // For now, default to Base Feed if none selected? Or empty?
            // "Defaults to Base Feed logic handled in currentDisplayItems"
            
        } catch {
            print("Failed to load configuration: \(error)")
            self.rssFeeds = RSSFeed.defaultFeeds
            self.userFeeds = [Feed.defaultFeed]
        }
    }
    
    func toggleFeed(_ feed: Feed) {
        if activeFeedIDs.contains(feed.id) {
            activeFeedIDs.remove(feed.id)
        } else {
            activeFeedIDs.insert(feed.id)
        }
    }
    
    func addUserFeed(_ feed: Feed) {
        userFeeds.append(feed)
        Task {
            try? await localStorage.saveUserFeeds(userFeeds)
        }
    }
    
    func removeUserFeed(_ feed: Feed) {
        userFeeds.removeAll { $0.id == feed.id }
        activeFeedIDs.remove(feed.id)
        Task {
            try? await localStorage.saveUserFeeds(userFeeds)
        }
    }
    
    // MARK: - Image Storage
    
    func saveFeedImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return filename
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    func loadImage(filename: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        if let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        
        return nil
    }
}

