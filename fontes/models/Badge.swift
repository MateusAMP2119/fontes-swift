import SwiftUI

struct Badge: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let isEarned: Bool
    let description: String // Added description for the detail view
}
