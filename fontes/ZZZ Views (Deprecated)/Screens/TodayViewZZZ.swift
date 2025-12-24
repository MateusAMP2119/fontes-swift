import SwiftUI

struct TodayViewZZ: View {
    @Binding var isSettingsPresented: Bool
    @State private var isReadingGoalsPresented = false
    
    // Sample Data matching the image
    let topStory = NewsArticle(
        source: "POLITICO",
        headline: "Hegseth says he won't release full boat-strike video",
        timeAgo: "19m ago",
        author: nil,
        imageName: "placeholder",
        imageURL: "https://images.impresa.pt/expresso/2025-12-08-ana-paula-martins-ministra-da-saude.jpg-a142d4a7/original",
        sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/1/16/Expresso_newspaper_logo.svg",
        isTopStory: true,
        tag: "More politics coverage",
        perspectives: [
            Perspective(sourceName: "CNN", sourceLogoName: "cnn", perspectiveType: .analysis, headline: "Legal experts weigh in on video release implications"),
            Perspective(sourceName: "Fox News", sourceLogoName: "fox", perspectiveType: .official, headline: "Defense department stands by decision"),
            Perspective(sourceName: "BBC", sourceLogoName: "bbc", perspectiveType: .global, headline: "International observers question transparency")
        ]
    )
    
    let gridStories: [NewsArticle] = [
        NewsArticle(
            source: "Los Angeles Times",
            headline: "The last U.S. pennies sell for $16.7 million",
            timeAgo: "1h ago",
            author: nil,
            imageName: "placeholder",
            imageURL: "https://images.impresa.pt/expresso/2025-12-08-paramount-f925e76a/original",
            sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%2Fid%2FOIP.qBh-8w8FD5zg5HaSHlGHdwHaC9%3Fpid%3DApi%26ucfimg%3D1&f=1&ipt=d5f384d5eb8f19806632badc6b40e5e3fd7fef790c60ad406ade190227f096ba&ipo=images",
            isTopStory: false,
            tag: nil,
            perspectives: [
                Perspective(sourceName: "Coin World", sourceLogoName: "coin", perspectiveType: .analysis, headline: "Why these pennies are worth a fortune"),
                Perspective(sourceName: "US Mint", sourceLogoName: "mint", perspectiveType: .official, headline: "History of the 1943 copper penny")
            ]
        ),
        NewsArticle(
            source: "Reuters",
            headline: "White House weighs risks of a health-care fight",
            timeAgo: "2h ago",
            author: nil,
            imageName: "placeholder",
            imageURL: "https://images.impresa.pt/expresso/2025-09-16-gettyimages-2213616252.jpg-5f7af722/original",
            sourceLogo: "https://images.assettype.com/dn/2024-12-30/d3rj8m67/DIARIONOTICIASPRETOLOGOJPEG.jpg",
            isTopStory: false,
            tag: nil,
            perspectives: [
                Perspective(sourceName: "The Hill", sourceLogoName: "hill", perspectiveType: .analysis, headline: "Political fallout of potential healthcare reform"),
                Perspective(sourceName: "White House Press", sourceLogoName: "wh", perspectiveType: .official, headline: "President outlines healthcare priorities")
            ]
        ),
        NewsArticle(
            source: "AP News",
            headline: "Trump administration says White House ballroom construction is a matter of national security",
            timeAgo: "3h ago",
            author: nil,
            imageName: "placeholder",
            imageURL: "https://images.impresa.pt/expresso/2025-12-08-trump-premio-paz-fifa-gianni-infantino-0ffdd882/original",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/1/16/Expresso_newspaper_logo.svg",
            isTopStory: false,
            tag: nil
        ),
        NewsArticle(
            source: "ABC News",
            headline: "New study shows coffee might actually be good for you",
            timeAgo: "4h ago",
            author: nil,
            imageName: "placeholder",
            imageURL: "https://images.impresa.pt/expresso/2025-12-05-acam0002.01418266_bb.png-e1fdbd0d/original",
            sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%2Fid%2FOIP.qBh-8w8FD5zg5HaSHlGHdwHaC9%3Fpid%3DApi%26ucfimg%3D1&f=1&ipt=d5f384d5eb8f19806632badc6b40e5e3fd7fef790c60ad406ade190227f096ba&ipo=images",
            isTopStory: false,
            tag: nil,
            perspectives: [
                Perspective(sourceName: "Healthline", sourceLogoName: "health", perspectiveType: .analysis, headline: "Benefits and risks of daily coffee consumption"),
                Perspective(sourceName: "Medical News Today", sourceLogoName: "medical", perspectiveType: .global, headline: "Global study confirms coffee's health benefits")
            ]
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // --- HEADER START ---
                    TodayHeaderView()
                    // --- HEADER END ---
                    
                    // Top Stories Section
                    LazyVStack(alignment: .leading, spacing: 16) {
                        // Main Top Story Card
                        PerspectiveNewsCard(article: topStory)
                            .padding(.horizontal)
                        
                        // Other stories
                        ForEach(gridStories) { article in
                            PerspectiveNewsCard(article: article)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .scrollEdgeEffectStyle(.soft, for: .all)
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}

#Preview {
    TodayViewZZ(isSettingsPresented: .constant(false))
}
