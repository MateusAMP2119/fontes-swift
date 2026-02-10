//
//  Feed.swift
//  Fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

/// A Feed is a curated collection of news sources, journalists, tags, and keywords
/// Similar to a playlist, but for news articles
struct Feed: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var description: String?
    var iconName: String
    var colorHex: String
    var imageURL: String?
    var sources: [String]
    var journalists: [String]
    var tags: [String]
    var keywords: [String]
    var createdAt: Date
    var updatedAt: Date
    var isPinned: Bool
    var isDefault: Bool // System-generated feeds like "New Episodes"
    
    var color: Color {
        Color(hex: colorHex) ?? .blue
    }
    
    var itemCount: Int {
        sources.count + journalists.count + tags.count + keywords.count
    }
    
    var subtitle: String {
        var components: [String] = []
        if !sources.isEmpty {
            components.append("\(sources.count) source\(sources.count == 1 ? "" : "s")")
        }
        if !journalists.isEmpty {
            components.append("\(journalists.count) journalist\(journalists.count == 1 ? "" : "s")")
        }
        if !tags.isEmpty {
            components.append("\(tags.count) tag\(tags.count == 1 ? "" : "s")")
        }
        if !keywords.isEmpty {
            components.append("\(keywords.count) keyword\(keywords.count == 1 ? "" : "s")")
        }
        return components.isEmpty ? "Empty feed" : components.joined(separator: " • ")
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String? = nil,
        iconName: String = "newspaper",
        colorHex: String = "#FF0000",
        imageURL: String? = nil,
        sources: [String] = [],
        journalists: [String] = [],
        tags: [String] = [],
        keywords: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isPinned: Bool = false,
        isDefault: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconName = iconName
        self.colorHex = colorHex
        self.imageURL = imageURL
        self.sources = sources
        self.journalists = journalists
        self.tags = tags
        self.keywords = keywords
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isPinned = isPinned
        self.isDefault = isDefault
    }
    func matches(_ item: ReadingItem) -> Bool {
        if isDefault {
            return true
        }
        
        let matchesSource = sources.isEmpty || sources.contains(item.source)
        let matchesJournalist = journalists.isEmpty || journalists.contains(item.author)
        let matchesTags = tags.isEmpty || !Set(tags).isDisjoint(with: Set(item.tags))
        
        return matchesSource && matchesJournalist && matchesTags
    }
}

// MARK: - Default Feed
extension Feed {
    /// Default feed that includes all available RSS sources
    static var defaultFeed: Feed {
        let allSources = RSSFeed.defaultFeeds.map { $0.name }
        return Feed(
            name: "Para ti",
            description: "All articles from your sources",
            iconName: "newspaper.fill",
            colorHex: "#FF0000",
            imageURL: nil,
            sources: allSources,
            journalists: [],
            tags: [],
            keywords: [],
            isPinned: true,
            isDefault: true
        )
    }
}
