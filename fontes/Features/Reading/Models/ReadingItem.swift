//
//  ArticleItem.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct ArticleItem: Identifiable, Hashable {
    let id: Int
    let title: String
    let source: String
    let time: String
    let author: String
    let tags: [String]
    let sourceLogo: String
    let mainColor: Color
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(source)
        hasher.combine(time)
        hasher.combine(author)
        hasher.combine(tags)
        hasher.combine(sourceLogo)
    }
    
    static func == (lhs: ArticleItem, rhs: ArticleItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.source == rhs.source &&
        lhs.time == rhs.time &&
        lhs.author == rhs.author &&
        lhs.tags == rhs.tags &&
        lhs.sourceLogo == rhs.sourceLogo
    }
}
