//
//  ArticleItem.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct ReadingItem: Identifiable, Hashable {
    let id: String
    let title: String
    let source: String
    let time: String
    let author: String
    let tags: [String]
    let sourceLogo: String
    let mainColor: Color
    let articleURL: String?
    let imageURL: String?
    let publishedDate: Date?
    
    // Convenience initializer for backward compatibility
    init(id: Int, title: String, source: String, time: String, author: String, tags: [String], sourceLogo: String, mainColor: Color) {
        self.id = String(id)
        self.title = title
        self.source = source
        self.time = time
        self.author = author
        self.tags = tags
        self.sourceLogo = sourceLogo
        self.mainColor = mainColor
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
        self.mainColor = mainColor
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
    
    private static func formatRelativeTime(from date: Date?) -> String {
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
