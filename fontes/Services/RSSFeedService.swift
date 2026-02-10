//
//  RSSFeedService.swift
//  Fontes
//
//  Created by Mateus Costa on 10/01/2026.
//

import Foundation
import SwiftUI



// MARK: - RSS Parser

class RSSParser: NSObject, XMLParserDelegate {
    private var items: [RSSItem] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentDescription = ""
    private var currentLink = ""
    private var currentPubDate = ""
    private var currentAuthor = ""
    private var currentCategories: [String] = []
    private var currentImageURL: String?
    private var isInsideItem = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return formatter
    }()
    
    private let altDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    func parse(data: Data) -> [RSSItem] {
        items = []
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return items
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        
        if elementName == "item" || elementName == "entry" {
            isInsideItem = true
            currentTitle = ""
            currentDescription = ""
            currentLink = ""
            currentPubDate = ""
            currentAuthor = ""
            currentCategories = []
            currentImageURL = nil
        }
        
        // Handle media:content or enclosure for images
        if isInsideItem {
            if elementName == "media:content" || elementName == "media:thumbnail" {
                if let url = attributeDict["url"], currentImageURL == nil {
                    currentImageURL = url
                }
            } else if elementName == "enclosure" {
                if let type = attributeDict["type"], type.hasPrefix("image"),
                   let url = attributeDict["url"] {
                    currentImageURL = url
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard isInsideItem else { return }
        
        switch currentElement {
        case "title":
            currentTitle += string
        case "description", "summary", "content:encoded":
            currentDescription += string
        case "link":
            currentLink += string
        case "pubDate", "published", "updated":
            currentPubDate += string
        case "author", "dc:creator":
            currentAuthor += string
        case "category":
            if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                currentCategories.append(string.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" || elementName == "entry" {
            let pubDate = dateFormatter.date(from: currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines))
                ?? altDateFormatter.date(from: currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines))
            
            // Try to extract image from description if not found elsewhere
            var imageURL = currentImageURL
            if imageURL == nil {
                imageURL = extractImageURL(from: currentDescription)
            }
            
            let item = RSSItem(
                title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                description: stripHTML(from: currentDescription).trimmingCharacters(in: .whitespacesAndNewlines),
                link: currentLink.trimmingCharacters(in: .whitespacesAndNewlines),
                pubDate: pubDate,
                author: currentAuthor.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : currentAuthor.trimmingCharacters(in: .whitespacesAndNewlines),
                categories: currentCategories,
                imageURL: imageURL
            )
            items.append(item)
            isInsideItem = false
        }
    }
    
    private func stripHTML(from string: String) -> String {
        guard let data = string.data(using: .utf8) else { return string }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        }
        
        // Fallback: simple regex-based strip
        return string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
    
    private func extractImageURL(from html: String) -> String? {
        let pattern = #"<img[^>]+src=["']([^"']+)["']"#
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
           let match = regex.firstMatch(in: html, options: [], range: NSRange(html.startIndex..., in: html)),
           let range = Range(match.range(at: 1), in: html) {
            return String(html[range])
        }
        return nil
    }
}

// MARK: - RSS Feed Service

actor RSSFeedService {
    static let shared = RSSFeedService()
    
    private let session: URLSession
    private let parser = RSSParser()
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config)
    }
    
    func fetchFeed(_ feed: RSSFeed) async throws -> [RSSItem] {
        var request = URLRequest(url: feed.url)
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15", forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw RSSError.invalidResponse
        }
        
        return parser.parse(data: data)
    }
    
    func fetchAllFeeds(_ feeds: [RSSFeed] = RSSFeed.defaultFeeds) async -> [(feed: RSSFeed, items: [RSSItem])] {
        await withTaskGroup(of: (RSSFeed, [RSSItem])?.self) { group in
            for feed in feeds {
                group.addTask {
                    do {
                        let items = try await self.fetchFeed(feed)
                        return (feed, items)
                    } catch {
                        print("Failed to fetch \(feed.name): \(error)")
                        return nil
                    }
                }
            }
            
            var results: [(RSSFeed, [RSSItem])] = []
            for await result in group {
                if let result = result {
                    results.append(result)
                }
            }
            return results
        }
    }
}

// MARK: - Errors

enum RSSError: Error, LocalizedError {
    case invalidResponse
    case parsingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from RSS feed"
        case .parsingFailed:
            return "Failed to parse RSS feed"
        }
    }
}
