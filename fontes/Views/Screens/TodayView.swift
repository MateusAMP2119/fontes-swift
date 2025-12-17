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
            isTopStory: false,
            tag: nil
        ),
        NewsArticle(
            source: "Reuters",
            headline: "White House weighs risks of a health-care fight",
            timeAgo: "2h ago",
            author: nil,
            imageName: "placeholder",
            isTopStory: false,
            tag: nil
        ),
        NewsArticle(
            source: "AP News",
            headline: "Trump administration says White House ballroom construction is a matter of national security",
            timeAgo: "3h ago",
            author: nil,
            imageName: "placeholder",
            isTopStory: false,
            tag: nil
        ),
        NewsArticle(
            source: "ABC News",
            headline: "New study shows coffee might actually be good for you",
            timeAgo: "4h ago",
            author: nil,
            imageName: "placeholder",
            isTopStory: false,
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
                        
                        // Grid for other stories
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(gridStories) { article in
                                NewsCardView(article: article)
                            }
                        }
                        .padding(.horizontal)
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
