import SwiftUI

struct TodayView: View {
    @Binding var isSettingsPresented: Bool
    
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
        tag: "More politics coverage"
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
            isTopStory: true,
            tag: nil
        ),
        NewsArticle(
            source: "Reuters",
            headline: "White House weighs risks of a health-care fight",
            timeAgo: "2h ago",
            author: nil,
            imageName: "placeholder",
            imageURL: "https://images.impresa.pt/expresso/2025-09-16-gettyimages-2213616252.jpg-5f7af722/original",
            sourceLogo: "https://images.assettype.com/dn/2024-12-30/d3rj8m67/DIARIONOTICIASPRETOLOGOJPEG.jpg",
            isTopStory: true,
            tag: nil
        ),
        NewsArticle(
            source: "AP News",
            headline: "Trump administration says White House ballroom construction is a matter of national security",
            timeAgo: "3h ago",
            author: nil,
            imageName: "placeholder",
            imageURL: "https://images.impresa.pt/expresso/2025-12-08-trump-premio-paz-fifa-gianni-infantino-0ffdd882/original",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/1/16/Expresso_newspaper_logo.svg",
            isTopStory: true,
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
            isTopStory: true,
            tag: nil
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
                    VStack(alignment: .leading, spacing: 16) {
                        // Main Top Story Card
                        NewsCardView(article: topStory)
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Fresh articles")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Other stories
                        ForEach(gridStories) { article in
                            NewsCardView(article: article)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .scrollEdgeEffectStyle(.soft, for: .all)
            .background(Color(uiColor: .systemGroupedBackground))
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {}) {
                        Text("Get News+")
                            .font(.system(size: 17, weight: .bold))
                    }
                }
            }
            .toolbar(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    TodayView(isSettingsPresented: .constant(false))
}
