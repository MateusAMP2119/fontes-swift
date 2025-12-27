//
//  Algorithm.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import Foundation

struct Algorithm: Identifiable, Hashable {
    let id: UUID
    var name: String
    var tags: Set<String>
    var sources: Set<String>
    var journalists: Set<String>
    
    init(id: UUID = UUID(), name: String, tags: Set<String> = [], sources: Set<String> = [], journalists: Set<String> = []) {
        self.id = id
        self.name = name
        self.tags = tags
        self.sources = sources
        self.journalists = journalists
    }
}
