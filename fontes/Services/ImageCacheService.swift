//
//  ImageCacheService.swift
//  Fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI
import CryptoKit

/// Thread-safe memory cache shared instance
final class MemoryCache {
    static let shared = MemoryCache()
    private let cache = NSCache<NSString, UIImage>()
    
    init() {
        cache.countLimit = 200
    }
    
    func object(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func setObject(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}

/// Service responsible for caching images to disk for offline access and faster loading
actor ImageCacheService {
    static let shared = ImageCacheService()
    
    private let fileManager = FileManager.default
    // private let memoryCache = NSCache<NSString, UIImage>() // Removed in favor of MemoryCache.shared
    
    private var cacheDirectory: URL? {
        fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("ImageCache")
    }
    
    init() {
        createCacheDirectoryIfNeeded()
    }
    
    private func createCacheDirectoryIfNeeded() {
        guard let cacheDirectory = cacheDirectory else {
            print("ERROR: Could not resolve cache directory path")
            return
        }
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
                print("Created cache directory at: \(cacheDirectory.path)")
            } catch {
                print("ERROR: Failed to create cache directory: \(error)")
            }
        }
    }
    
    // MARK: - Cache Key Generation
    
    nonisolated func cacheKey(for url: URL) -> String {
        // Use SHA256 for a consistent, safe filename from the URL
        if let data = url.absoluteString.data(using: .utf8) {
            let hashed = SHA256.hash(data: data)
            return hashed.compactMap { String(format: "%02x", $0) }.joined()
        }
        
        // Fallback (should normally not happen with valid URLs)
        return UUID().uuidString
    }
    
    // MARK: - Image Retrieval
    
    /// Get image from cache (memory first, then disk)
    func getImage(for url: URL) async -> UIImage? {
        let key = cacheKey(for: url)
        
        // Check memory cache first
        if let cachedImage = MemoryCache.shared.object(forKey: key) {
            return cachedImage
        }
        
        // Check disk cache
        guard let cacheDirectory = cacheDirectory else { return nil }
        let fileURL = cacheDirectory.appendingPathComponent(key)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                if let image = UIImage(data: data) {
                    // Store in memory cache for faster access next time
                    MemoryCache.shared.setObject(image, forKey: key)
                    return image
                }
            } catch {
                print("ERROR: Failed to load image from disk: \(error)")
            }
        }
        
        return nil
    }
    
    /// Download and cache image
    func cacheImage(from url: URL) async -> UIImage? {
        // Check if already cached
        if let cachedImage = await getImage(for: url) {
            return cachedImage
        }
        
        // Download image
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("ERROR: Invalid response for \(url)")
                return nil
            }
            
            guard let image = UIImage(data: data) else {
                print("ERROR: Failed to decode image data from \(url)")
                return nil
            }
            
            // Save to disk cache
            let key = cacheKey(for: url)
            if let cacheDirectory = cacheDirectory {
                // Ensure directory exists (just in case)
                if !fileManager.fileExists(atPath: cacheDirectory.path) {
                    createCacheDirectoryIfNeeded()
                }
                
                let fileURL = cacheDirectory.appendingPathComponent(key)
                do {
                    try data.write(to: fileURL, options: .atomic)
                    // print("Saved image to disk: \(fileURL.lastPathComponent)")
                } catch {
                    print("ERROR: Failed to write image to \(fileURL.path): \(error)")
                }
            }
            
            // Save to memory cache
            MemoryCache.shared.setObject(image, forKey: key)
            
            return image
        } catch {
            print("ERROR: Failed to download image from \(url): \(error)")
            return nil
        }
    }
    
    // MARK: - Preloading
    
    /// Preload multiple images concurrently
    func preloadImages(urls: [URL]) async {
        await withTaskGroup(of: Void.self) { group in
            for url in urls {
                group.addTask {
                    _ = await self.cacheImage(from: url)
                }
            }
        }
    }
    
    /// Preload images for reading items (article images + source logos)
    func preloadImages(for items: [ReadingItem], limit: Int = 10) async {
        var urls: [URL] = []
        
        for item in items.prefix(limit) {
            // Add article image URL
            if let imageURLString = item.imageURL, let url = URL(string: imageURLString) {
                urls.append(url)
            }
            // Add source logo URL
            if let logoURL = URL(string: item.sourceLogo) {
                urls.append(logoURL)
            }
        }
        
        await preloadImages(urls: urls)
    }
    
    // MARK: - Cache Management
    
    /// Clear all cached images
    func clearCache() async {
        MemoryCache.shared.removeAll()
        
        guard let cacheDirectory = cacheDirectory else { return }
        
        if let contents = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil) {
            for fileURL in contents {
                try? fileManager.removeItem(at: fileURL)
            }
        }
    }
    
    /// Get cache size in bytes
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

// MARK: - Cached Async Image View

/// A drop-in replacement for AsyncImage that uses disk caching
struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State private var image: UIImage?
    @State private var isLoading = true
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
        
        // Attempt synchronous load from memory cache
        if let url = url {
             // We can use the nonisolated cache key generation manually or expose it
             // Let's replicate the safe hash logic or make cacheKey nonisolated (it is pure logic)
             // I made cacheKey nonisolated above.
             // Accessing ImageCacheService.shared.cacheKey is possible? 
             // No, standard actors don't expose nonisolated methods easily to sync context without warnings in some swift versions,
             // but `nonisolated` keyword allows it.
             
             // However, `ImageCacheService.shared` is an actor instance.
             // Calling `ImageCacheService.shared.cacheKey(for: url)` from sync context:
             // "Actor-isolated instance method 'cacheKey(for:)' can not be referenced from a non-isolated context"
             // Unless it IS nonisolated. I marked it nonisolated above.
             
             // Wait, I need to verify if I can call it.
             // If not, I'll dulicate logic or move it to MemoryCache.
             // Let's duplicates logic for safety/speed here to avoid actor hop entirely?
             // Or better: Move `cacheKey` to `MemoryCache` or a static helper.
        }
        
        // Checking cache synchronously in init to set initial state
         if let url = url,
            let data = url.absoluteString.data(using: .utf8) {
             let hashed = SHA256.hash(data: data)
             let key = hashed.compactMap { String(format: "%02x", $0) }.joined()
             
             if let cached = MemoryCache.shared.object(forKey: key) {
                 _image = State(initialValue: cached)
                 _isLoading = State(initialValue: false)
             }
         }
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else if isLoading {
                placeholder()
                    .task(id: url) {
                        await loadImage()
                    }
            } else {
                // Loaded but failed (nil image), or url was nil
                placeholder()
            }
        }
    }
    
    private func loadImage() async {
        guard let url = url, image == nil else { return }
        
        // isLoading is already managed by init or body state, but we ensure it's true if we are here
        // actually if image is nil and we are here, isLoading should be true.
        
        if let cachedImage = await ImageCacheService.shared.getImage(for: url) {
            self.image = cachedImage
            self.isLoading = false
            return
        }
        
        if let downloadedImage = await ImageCacheService.shared.cacheImage(from: url) {
            self.image = downloadedImage
        }
        
        self.isLoading = false
    }
}

// MARK: - Convenience Initializers

extension CachedAsyncImage where Placeholder == ProgressView<EmptyView, EmptyView> {
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        self.init(url: url, content: content, placeholder: { ProgressView() })
    }
}

extension CachedAsyncImage where Content == Image, Placeholder == ProgressView<EmptyView, EmptyView> {
    init(url: URL?) {
        self.init(url: url, content: { $0 }, placeholder: { ProgressView() })
    }
}
