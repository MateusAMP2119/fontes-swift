//
//  ArticleItem.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import Foundation

struct ArticleItem: Identifiable {
    let id: Int
    let title: String
    let source: String
    let time: String
    let author: String
    let tags: [String]
    let sourceLogo: String
}
