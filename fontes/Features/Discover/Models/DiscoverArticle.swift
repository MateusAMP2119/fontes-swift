//
//  DiscoverArticle.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import SwiftUI

struct DiscoverArticle: Identifiable, Hashable {
    let id: UUID
    let imageName: String
    let title: String
    let subtitle: String
    let details: String
    let isFollowing: Bool
    let color: Color

    init(id: UUID = UUID(), imageName: String, title: String, subtitle: String, details: String, isFollowing: Bool, color: Color) {
        self.id = id
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.details = details
        self.isFollowing = isFollowing
        self.color = color
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(imageName)
        hasher.combine(title)
        hasher.combine(subtitle)
        hasher.combine(details)
        hasher.combine(isFollowing)
    }

    static func == (lhs: DiscoverArticle, rhs: DiscoverArticle) -> Bool {
        lhs.id == rhs.id &&
        lhs.imageName == rhs.imageName &&
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.details == rhs.details &&
        lhs.isFollowing == rhs.isFollowing
    }
    
    var asReadingItem: ReadingItem {
        // Map DiscoverArticle to ReadingItem
        // Using hash of ID for the Int ID requirement of ReadingItem
        var hasher = Hasher()
        hasher.combine(id)
        let intId = hasher.finalize()
        
        return ReadingItem(
            id: intId,
            title: title,
            source: subtitle.replacingOccurrences(of: "By ", with: ""),
            time: "Recently", // Discover doesn't have time, default to Recently
            author: subtitle.replacingOccurrences(of: "By ", with: ""),
            tags: [], // Discover items don't have tags in this model
            sourceLogo: imageName,
            mainColor: color
        )
    }
}
