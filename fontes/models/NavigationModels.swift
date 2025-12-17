import SwiftUI

struct Algorithm: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
    var isSelected: Bool
}

enum TodayFilter: String, CaseIterable, Identifiable {
    case recent = "Recent"
    case impactful = "Impactful"
    case breaking = "Breaking"
    
    var id: String { self.rawValue }
    var icon: String {
        switch self {
        case .recent: return "clock"
        case .impactful: return "arrow.up.right.circle"
        case .breaking: return "burst"
        }
    }
}

struct Folder: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
}
