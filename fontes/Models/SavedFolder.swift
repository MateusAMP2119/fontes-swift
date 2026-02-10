//
//  SavedFolder.swift
//  Fontes
//
//  Created by Mateus Costa on 13/01/2026.
//

import Foundation
import SwiftUI

/// A user-created folder to organize saved articles
struct SavedFolder: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var iconName: String
    var imageURL: String?
    var description: String?
    var createdAt: Date
    var updatedAt: Date
    // For now, we store IDs. In a real app we might store full items or a relationship
    var itemIDs: [String]
    
    init(
        id: UUID = UUID(),
        name: String,
        iconName: String = "folder",
        imageURL: String? = nil,
        description: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        itemIDs: [String] = []
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.imageURL = imageURL
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.itemIDs = itemIDs
    }
}
