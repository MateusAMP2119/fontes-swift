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
    
    // User-created Saved Folders
    @Published var savedFolders: [SavedFolder] = []
    
    // Active Filters (WHERE clause style)
    @Published var activeTags: Set<String> = []
    @Published var activeAuthors: Set<String> = []
    @Published var activeSources: Set<String> = []
    
    var hasActiveFilters: Bool {
        !activeTags.isEmpty || !activeAuthors.isEmpty || !activeSources.isEmpty
    }
    
    // Toast State
    @Published var showingSaveToast = false
    @Published var lastSavedItem: ReadingItem?
    
    // Cache duration in seconds (5 minutes for network, 24 hours max for offline)
    private let cacheDuration: TimeInterval = 300
    private let maxCacheAge: TimeInterval = 86400 // 24 hours
    
    // Number of images to preload for initial display
    private let pageSize = 30
    
    private var allFetchedItems: [ReadingItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    // Pagination State
    var canLoadMore: Bool {
        items.count < allFetchedItems.count
    }
    @Published var isFetchingMore = false
    
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
    
    // ... items based getters ...
    
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
        
        // Prepare for sequential fetching
        let activeRSSFeeds = rssFeeds.filter { $0.isEnabled }
        
        // Run fetching in detached task to avoid blocking main thread
        await Task.detached(priority: .userInitiated) {
            var allItems: [ReadingItem] = []
            var lastSavedCount = 0
            let saveInterval = 60
            
            // Local deduplication helper
            func dedup(_ items: [ReadingItem]) -> [ReadingItem] {
                var seen = Set<String>()
                return items.filter { item in
                    let normalizedTitle = item.title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                    if seen.contains(normalizedTitle) { return false }
                    seen.insert(normalizedTitle)
                    return true
                }
            }

            for feed in activeRSSFeeds {
                do {
                    // Fetch feed sequentially (one at a time)
                    let rssItems = try await RSSFeedService.shared.fetchFeed(feed)
                    let newItems = rssItems.map { ReadingItem.from(rssItem: $0, feed: feed) }
                    
                    allItems.append(contentsOf: newItems)
                    
                    // Periodically save to storage
                    if allItems.count - lastSavedCount >= saveInterval {
                        let currentItems = dedup(allItems).sorted {
                            ($0.publishedDate ?? Date()) > ($1.publishedDate ?? Date())
                        }
                        try? await LocalStorageService.shared.saveFeedItems(currentItems)
                        lastSavedCount = allItems.count
                    }
                } catch {
                    print("Error fetching feed \(feed.name): \(error)")
                }
            }
            
            // Final processing
            let finalItems = dedup(allItems).sorted {
                ($0.publishedDate ?? Date()) > ($1.publishedDate ?? Date())
            }
            
            // Update MainActor state
            await MainActor.run {
                self.allFetchedItems = finalItems
                
                // Pagination: only expose first page initially
                let initialPage = Array(finalItems.prefix(self.pageSize))
                self.items = initialPage
                
                self.lastUpdated = Date()
                self.dataSource = .network
                self.isLoading = false
                self.isInitialLoading = false
                
                if finalItems.isEmpty {
                    self.error = RSSError.parsingFailed
                }
                
                // Preload images for FIRST page in background
                Task(priority: .background) {
                    await self.preloadImagesForBatch(initialPage)
                }
            }
            
            // Final save to ensure consistency
            try? await LocalStorageService.shared.saveFeedItems(finalItems)
            
        }.value
    }
    
    /// Load items from local cache
    private func loadFromCache() async {
        do {
            let cachedItems = try await localStorage.loadFeedItems()
            if !cachedItems.isEmpty {
                self.allFetchedItems = cachedItems
                let initialPage = Array(cachedItems.prefix(pageSize))
                self.items = initialPage
                
                self.dataSource = .cache
                
                // Get cache metadata for last updated time
                if let metadata = await localStorage.getCacheMetadata() {
                    self.lastUpdated = metadata.lastUpdated
                }
                
                // Preload images for cached items in background
                Task(priority: .background) {
                    await preloadImagesForBatch(initialPage)
                }
            } else {
                self.error = LocalStorageError.fileNotFound
            }
        } catch {
            self.error = error
        }
        
        self.isLoading = false
        self.isInitialLoading = false
    }
    
    /// Load more items from the fetched set
    func loadMore() async {
        // Prevent concurrent loads or loading if done
        guard canLoadMore, !isLoading, !isFetchingMore else { return }
        
        isFetchingMore = true
        defer { isFetchingMore = false }
        
        let currentCount = items.count
        let nextBatch = Array(allFetchedItems.dropFirst(currentCount).prefix(pageSize))
        
        guard !nextBatch.isEmpty else { return }
        
        print("Loading more... \(nextBatch.count) items")
        
        // Append to items immediately for instant UI update
        self.items.append(contentsOf: nextBatch)
        
        // Preload next batch images in background (don't block UI)
        Task(priority: .background) {
            await preloadImagesForBatch(nextBatch)
        }
    }
    
    /// Preload images for a specific batch of items
    private func preloadImagesForBatch(_ items: [ReadingItem]) async {
        print("Preloading images for batch of \(items.count) items")
        await imageCache.preloadImages(for: items, limit: items.count)
        if self.items.count <= pageSize {
             self.imagesPreloaded = true
        }
    }
    
    /// Preload cached data on app launch
    func preloadCachedData() async {
        // Load from cache first for instant display
        if let cachedItems = try? await localStorage.loadFeedItems(), !cachedItems.isEmpty {
            self.allFetchedItems = cachedItems
            
            let initialPage = Array(cachedItems.prefix(pageSize))
            self.items = initialPage
            
            self.dataSource = .cache
            
            self.isInitialLoading = false
            
            // Preload images for cached items in background
            Task(priority: .background) {
                await preloadImagesForBatch(initialPage)
            }
            
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
        var filtered = items.filter { item in
            activeFeeds.contains { feed in
                feed.matches(item)
            }
        }
        
        // Apply "WHERE" clause filters (AND logic between categories)
        if !activeTags.isEmpty {
            filtered = filtered.filter { item in
                !Set(item.tags).isDisjoint(with: activeTags)
            }
        }
        
        if !activeAuthors.isEmpty {
            filtered = filtered.filter { item in
                activeAuthors.contains(item.author)
            }
        }
        
        if !activeSources.isEmpty {
            filtered = filtered.filter { item in
                activeSources.contains(item.source)
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
            
            // Preload all RSS feed logos for FeedIconCollage
            let logoURLs = self.rssFeeds.compactMap { URL(string: $0.logoURL) }
            Task {
                await imageCache.preloadImages(urls: logoURLs)
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
            
            // Load Saved Folders
            let loadedFolders = try await localStorage.loadSavedFolders()
            self.savedFolders = loadedFolders
            
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
    
    // MARK: - Saved Folders Management
    
    func createFolder(name: String, iconName: String = "folder", imageURL: String? = nil, description: String? = nil) {
        let folder = SavedFolder(name: name, iconName: iconName, imageURL: imageURL, description: description)
        savedFolders.append(folder)
        saveSavedFolders()
    }
    
    func deleteFolder(_ folder: SavedFolder) {
        savedFolders.removeAll { $0.id == folder.id }
        saveSavedFolders()
    }
    
    func updateFolder(_ folder: SavedFolder) {
        if let index = savedFolders.firstIndex(where: { $0.id == folder.id }) {
            savedFolders[index] = folder
            saveSavedFolders()
        }
    }
    
    private func saveSavedFolders() {
        Task {
            try? await localStorage.saveSavedFolders(savedFolders)
        }
    }
    
    // MARK: - Folder Item Management
    
    func addToFolder(_ folder: SavedFolder, item: ReadingItem) {
        if let index = savedFolders.firstIndex(where: { $0.id == folder.id }) {
            var updatedFolder = savedFolders[index]
            if !updatedFolder.itemIDs.contains(item.id) {
                updatedFolder.itemIDs.append(item.id)
                updatedFolder.updatedAt = Date()
                savedFolders[index] = updatedFolder
                saveSavedFolders()
            }
        }
    }
    
    func removeFromFolder(_ folder: SavedFolder, item: ReadingItem) {
        if let index = savedFolders.firstIndex(where: { $0.id == folder.id }) {
            var updatedFolder = savedFolders[index]
            updatedFolder.itemIDs.removeAll { $0 == item.id }
            updatedFolder.updatedAt = Date()
            savedFolders[index] = updatedFolder
            saveSavedFolders()
        }
    }
    
    func savedInFolders(_ item: ReadingItem) -> [SavedFolder] {
        savedFolders.filter { $0.itemIDs.contains(item.id) }
    }
    
    func isSaved(_ item: ReadingItem) -> Bool {
        !savedInFolders(item).isEmpty
    }
    
    func toggleSaved(_ item: ReadingItem) {
        if isSaved(item) {
            // Remove from ALL folders
            let folders = savedInFolders(item)
            for folder in folders {
                removeFromFolder(folder, item: item)
            }
            // Hide toast if we just unsaved the item being shown
            if lastSavedItem?.id == item.id {
                showingSaveToast = false
                lastSavedItem = nil
            }
        } else {
            // Add to "Saved Stories" folder, creating if needed
            let defaultFromName = "Saved Stories"
            if let savedFolder = savedFolders.first(where: { $0.name == defaultFromName }) {
                addToFolder(savedFolder, item: item)
            } else {
                createFolder(name: defaultFromName)
                // Re-fetch because createFolder appends to savedFolders
                if let newFolder = savedFolders.first(where: { $0.name == defaultFromName }) {
                    addToFolder(newFolder, item: item)
                }
            }
            
            // Trigger Toast
            lastSavedItem = item
            withAnimation {
                showingSaveToast = true
            }
            
            // Auto hide after 3 seconds
            Task {
                try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                if lastSavedItem?.id == item.id {
                    await MainActor.run {
                        withAnimation {
                            showingSaveToast = false
                        }
                    }
                }
            }
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

