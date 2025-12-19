import Foundation

enum PerspectiveType: String, Codable {
    case official
    case global
    case analysis
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
