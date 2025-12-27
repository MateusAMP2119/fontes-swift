//
//  DiscoverArticle.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import SwiftUI

struct DiscoverArticle: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
    let details: String
    let isFollowing: Bool
    let color: Color

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
}
