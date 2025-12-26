import Foundation
import SwiftUI

enum PerspectiveType: String, Codable {
    case analysis
    case official
    case global
    case local
    
    var themeColor: Color {
        switch self {
        case .analysis:
            return .perspectiveAnalysis
        case .official:
            return .perspectiveOfficial
        case .global:
            return .perspectiveGlobal
        case .local:
            return .perspectiveLocal
        }
    }
}

struct Perspective: Identifiable {
    let id = UUID()
    let sourceName: String
    let sourceLogoName: String
    let perspectiveType: PerspectiveType
    let headline: String
}

struct NewsArticle: Identifiable {
    let id = UUID()
    let source: String
    let headline: String
    let timeAgo: String
    let author: String?
    let imageName: String
    let imageURL: String?
    let sourceLogo: String?
    let isTopStory: Bool
    let tag: String?
    var perspectives: [Perspective]? = nil
}
