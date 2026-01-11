//
//  LocalStorageService.swift
//  fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import Foundation

/// Service responsible for persisting feed data locally for offline access
actor LocalStorageService {
    static let shared = LocalStorageService()
    
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // File names for different cached data
    private let feedItemsFileName = "cached_feed_items.json"
    private let cacheMetadataFileName = "cache_metadata.json"
    
    private var cacheDirectory: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("FeedCache")
    }
    
    init() {
        createCacheDirectoryIfNeeded()
    }
    
    // MARK: - Cache Directory Management
    
    private func createCacheDirectoryIfNeeded() {
        guard let cacheDirectory = cacheDirectory else { return }
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    // MARK: - Feed Items Cache
    
    /// Save feed items to local storage
    func saveFeedItems(_ items: [ReadingItem]) async throws {
        guard let cacheDirectory = cacheDirectory else {
            throw LocalStorageError.cacheDirectoryNotAvailable
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(feedItemsFileName)
        let data = try encoder.encode(items)
        try data.write(to: fileURL, options: .atomic)
        
        // Update cache metadata
        try await updateCacheMetadata()
    }
    
    /// Load feed items from local storage
    func loadFeedItems() async throws -> [ReadingItem] {
        guard let cacheDirectory = cacheDirectory else {
            throw LocalStorageError.cacheDirectoryNotAvailable
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(feedItemsFileName)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        let data = try Data(contentsOf: fileURL)
        let items = try decoder.decode([ReadingItem].self, from: data)
        
        // Update relative time strings based on current date
        return items.map { $0.withUpdatedTime() }
    }
    
    // MARK: - Cache Metadata
    
    private func updateCacheMetadata() async throws {
        guard let cacheDirectory = cacheDirectory else { return }
        
        let metadata = CacheMetadata(lastUpdated: Date())
        let fileURL = cacheDirectory.appendingPathComponent(cacheMetadataFileName)
        let data = try encoder.encode(metadata)
        try data.write(to: fileURL, options: .atomic)
    }
    
    /// Get the last update date of the cache
    func getCacheMetadata() async -> CacheMetadata? {
        guard let cacheDirectory = cacheDirectory else { return nil }
        
        let fileURL = cacheDirectory.appendingPathComponent(cacheMetadataFileName)
        
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let metadata = try? decoder.decode(CacheMetadata.self, from: data) else {
            return nil
        }
        
        return metadata
    }
    
    /// Check if cache is valid (not expired)
    func isCacheValid(maxAge: TimeInterval) async -> Bool {
        guard let metadata = await getCacheMetadata() else { return false }
        return Date().timeIntervalSince(metadata.lastUpdated) < maxAge
    }
    
    // MARK: - Cache Cleanup
    
    /// Clear all cached data
    func clearCache() async throws {
        guard let cacheDirectory = cacheDirectory else { return }
        
        let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
        for fileURL in contents {
            try fileManager.removeItem(at: fileURL)
        }
    }
    
    /// Get the size of the cache in bytes
    func getCacheSize() async -> Int64 {
        guard let cacheDirectory = cacheDirectory else { return 0 }
        
        var totalSize: Int64 = 0
        
        if let contents = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey]) {
            for fileURL in contents {
                if let size = try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                    totalSize += Int64(size)
                }
            }
        }
        
        return totalSize
    }
}

// MARK: - Cache Metadata Model

struct CacheMetadata: Codable {
    let lastUpdated: Date
    
    var formattedLastUpdated: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: lastUpdated, relativeTo: Date())
    }
}

// MARK: - Local Storage Errors

enum LocalStorageError: Error, LocalizedError {
    case cacheDirectoryNotAvailable
    case encodingFailed
    case decodingFailed
    case fileNotFound
    
    var errorDescription: String? {
        switch self {
        case .cacheDirectoryNotAvailable:
            return "Cache directory is not available"
        case .encodingFailed:
            return "Failed to encode data for storage"
        case .decodingFailed:
            return "Failed to decode stored data"
        case .fileNotFound:
            return "Cached file not found"
        }
    }
}
