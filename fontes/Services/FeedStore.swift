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
    @Published var error: Error?
    @Published var lastUpdated: Date?
    
    private let service = RSSFeedService.shared
    private let feeds: [RSSFeed]
    
    // Cache duration in seconds (5 minutes)
    private let cacheDuration: TimeInterval = 300
    
    init(feeds: [RSSFeed] = RSSFeed.defaultFeeds) {
        self.feeds = feeds
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
        
        let results = await service.fetchAllFeeds(feeds)
        
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
        self.isLoading = false
        
        if allItems.isEmpty && !results.isEmpty {
            self.error = RSSError.parsingFailed
        }
    }
    
    func refresh() async {
        await loadFeeds(forceRefresh: true)
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
}
