//
//  GoalModels.swift
//  fontes
//
//  Created by Mateus Costa on 26/12/2025.
//

import SwiftUI

// Shared Badge Model
struct Badge: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let isEarned: Bool
}

let mockBadges: [Badge] = [
    Badge(name: "First Step", icon: "shoe.fill", color: .blue, isEarned: true),
    Badge(name: "7-Day Streak", icon: "flame.fill", color: .orange, isEarned: true),
    Badge(name: "Bookworm", icon: "book.closed.fill", color: .purple, isEarned: false),
    Badge(name: "Early Bird", icon: "sunrise.fill", color: .yellow, isEarned: false),
    Badge(name: "Night Owl", icon: "moon.stars.fill", color: .indigo, isEarned: false),
    Badge(name: "Weekend", icon: "party.popper.fill", color: .green, isEarned: true)
]
