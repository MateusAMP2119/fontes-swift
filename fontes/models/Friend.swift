import SwiftUI

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let avatar: String
    let badges: [Badge]
}
