//
//  DiscoverTopic.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import Foundation

struct TopicData: Identifiable {
    let id = UUID()
    let rank: Int
    let title: String
    let trend: TopicTrend
    let change: String
}

enum TopicTrend {
    case up, down, stable
}
