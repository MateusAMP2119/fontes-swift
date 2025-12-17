import Foundation

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
}
