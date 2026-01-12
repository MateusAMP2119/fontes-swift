//
//  RSSItem.swift
//  fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import Foundation

struct RSSItem {
    let title: String
    let description: String
    let link: String
    let pubDate: Date?
    let author: String?
    let categories: [String]
    let imageURL: String?
}
