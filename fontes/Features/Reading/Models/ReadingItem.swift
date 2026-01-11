//
//  ArticleItem.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct ReadingItem: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let source: String
    let time: String
    let author: String
    let tags: [String]
    let sourceLogo: String
    let mainColorHex: String // Store color as hex for Codable
    let articleURL: String?
    let imageURL: String?
    let publishedDate: Date?
    
    var mainColor: Color {
        Color(hex: mainColorHex) ?? .blue
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, source, time, author, tags, sourceLogo, mainColorHex, articleURL, imageURL, publishedDate
    }
    
    // Convenience initializer for backward compatibility
    init(id: Int, title: String, source: String, time: String, author: String, tags: [String], sourceLogo: String, mainColor: Color) {
        self.id = String(id)
        self.title = title
        self.source = source
        self.time = time
        self.author = author
        self.tags = tags
        self.sourceLogo = sourceLogo
        self.mainColorHex = mainColor.toHex() ?? "#0000FF"
        self.articleURL = nil
        self.imageURL = nil
        self.publishedDate = nil
    }
    
    // Full initializer
    init(id: String, title: String, source: String, time: String, author: String, tags: [String], sourceLogo: String, mainColor: Color, articleURL: String? = nil, imageURL: String? = nil, publishedDate: Date? = nil) {
        self.id = id
        self.title = title
        self.source = source
        self.time = time
        self.author = author
        self.tags = tags
        self.sourceLogo = sourceLogo
        self.mainColorHex = mainColor.toHex() ?? "#0000FF"
        self.articleURL = articleURL
        self.imageURL = imageURL
        self.publishedDate = publishedDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(source)
        hasher.combine(time)
        hasher.combine(author)
        hasher.combine(tags)
        hasher.combine(sourceLogo)
    }
    
    static func == (lhs: ReadingItem, rhs: ReadingItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.source == rhs.source &&
        lhs.time == rhs.time &&
        lhs.author == rhs.author &&
        lhs.tags == rhs.tags &&
        lhs.sourceLogo == rhs.sourceLogo
    }
    
    // MARK: - Factory Method for RSS Items
    
    static func from(rssItem: RSSItem, feed: RSSFeed) -> ReadingItem {
        let timeString = formatRelativeTime(from: rssItem.pubDate)
        let author = rssItem.author ?? feed.name
        
        return ReadingItem(
            id: rssItem.link.isEmpty ? UUID().uuidString : rssItem.link,
            title: rssItem.title,
            source: feed.name,
            time: timeString,
            author: author,
            tags: rssItem.categories.isEmpty ? ["News"] : Array(rssItem.categories.prefix(3)),
            sourceLogo: feed.logoURL,
            mainColor: feed.defaultColor,
            articleURL: rssItem.link,
            imageURL: rssItem.imageURL,
            publishedDate: rssItem.pubDate
        )
    }
    
    // Create a fresh copy with updated relative time
    func withUpdatedTime() -> ReadingItem {
        ReadingItem(
            id: id,
            title: title,
            source: source,
            time: ReadingItem.formatRelativeTime(from: publishedDate),
            author: author,
            tags: tags,
            sourceLogo: sourceLogo,
            mainColor: mainColor,
            articleURL: articleURL,
            imageURL: imageURL,
            publishedDate: publishedDate
        )
    }
    
    static func formatRelativeTime(from date: Date?) -> String {
        guard let date = date else { return "" }
        
        let now = Date()
        let interval = now.timeIntervalSince(date)
        
        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h"
        } else if interval < 604800 {
            let days = Int(interval / 86400)
            return "\(days)d"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
    }
}

// MARK: - Color Hex Extension

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let length = hexSanitized.count
        
        switch length {
        case 6:
            self.init(
                red: Double((rgb & 0xFF0000) >> 16) / 255.0,
                green: Double((rgb & 0x00FF00) >> 8) / 255.0,
                blue: Double(rgb & 0x0000FF) / 255.0
            )
        case 8:
            self.init(
                red: Double((rgb & 0xFF000000) >> 24) / 255.0,
                green: Double((rgb & 0x00FF0000) >> 16) / 255.0,
                blue: Double((rgb & 0x0000FF00) >> 8) / 255.0,
                opacity: Double(rgb & 0x000000FF) / 255.0
            )
        default:
            return nil
        }
    }
    
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        
        let r = components.count > 0 ? components[0] : 0
        let g = components.count > 1 ? components[1] : 0
        let b = components.count > 2 ? components[2] : 0
        
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
