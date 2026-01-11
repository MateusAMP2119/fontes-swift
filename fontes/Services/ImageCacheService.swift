//
//  ImageCacheService.swift
//  fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

/// Service responsible for caching images to disk for offline access and faster loading
actor ImageCacheService {
    static let shared = ImageCacheService()
    
    private let fileManager = FileManager.default
    private let memoryCache = NSCache<NSString, UIImage>()
    
    private var cacheDirectory: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("ImageCache")
    }
    
    init() {
        createCacheDirectoryIfNeeded()
        memoryCache.countLimit = 100 // Max 100 images in memory
    }
    
    private func createCacheDirectoryIfNeeded() {
        guard let cacheDirectory = cacheDirectory else { return }
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    // MARK: - Cache Key Generation
    
    private func cacheKey(for url: URL) -> String {
        // Create a safe filename from the URL
        let hash = url.absoluteString.data(using: .utf8)?.base64EncodedString() ?? UUID().uuidString
        return hash.replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .prefix(100) + ".img"
    }
    
    // MARK: - Image Retrieval
    
    /// Get image from cache (memory first, then disk)
    func getImage(for url: URL) async -> UIImage? {
        let key = cacheKey(for: url)
        
        // Check memory cache first
        if let cachedImage = memoryCache.object(forKey: key as NSString) {
            return cachedImage
        }
        
        // Check disk cache
        guard let cacheDirectory = cacheDirectory else { return nil }
        let fileURL = cacheDirectory.appendingPathComponent(key)
        
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        
        // Store in memory cache for faster access next time
        memoryCache.setObject(image, forKey: key as NSString)
        
        return image
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
                  (200...299).contains(httpResponse.statusCode),
                  let image = UIImage(data: data) else {
                return nil
            }
            
            // Save to disk cache
            let key = cacheKey(for: url)
            if let cacheDirectory = cacheDirectory {
                let fileURL = cacheDirectory.appendingPathComponent(key)
                try? data.write(to: fileURL, options: .atomic)
            }
            
            // Save to memory cache
            memoryCache.setObject(image, forKey: key as NSString)
            
            return image
        } catch {
            print("Failed to cache image from \(url): \(error)")
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
        memoryCache.removeAllObjects()
        
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
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else if isLoading {
                placeholder()
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url = url else {
            isLoading = false
            return
        }
        
        isLoading = true
        
        // Try to get from cache first (instant)
        if let cachedImage = await ImageCacheService.shared.getImage(for: url) {
            self.image = cachedImage
            isLoading = false
            return
        }
        
        // Download and cache
        if let downloadedImage = await ImageCacheService.shared.cacheImage(from: url) {
            self.image = downloadedImage
        }
        
        isLoading = false
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
