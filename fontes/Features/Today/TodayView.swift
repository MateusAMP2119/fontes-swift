//
//  TodayPage.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct TodayPage: View {
    @Binding var scrollProgress: Double
    
    // Sample data for the grid
    let items: [ArticleItem] = [
        ArticleItem(id: 1, title: "'I annoyed him a lot - I think that's why he was a little bit angry.", source: "dailymail.co.uk", time: "2h"),
        ArticleItem(id: 2, title: "Photoshop Troll Who Takes Photo Requests Too Literally Strikes Again, And The Result Is Hilarious", source: "boredpanda.com", time: "2h"),
        ArticleItem(id: 3, title: "New iPhone 16 Pro Max Review: The Best Just Got Better", source: "theverge.com", time: "4h"),
        ArticleItem(id: 4, title: "NASA's James Webb Space Telescope captures stunning new image of the Pillars of Creation", source: "nasa.gov", time: "8h"),
        ArticleItem(id: 5, title: "Why the future of renewable energy depends on this one critical mineral found in the deep ocean", source: "wired.com", time: "5h"),
        ArticleItem(id: 6, title: "Top 10 Places to Visit in Japan", source: "travelandleisure.com", time: "6h"),
        ArticleItem(id: 7, title: "The Ultimate Guide to Homemade Pasta", source: "bonappetit.com", time: "1h"),
        ArticleItem(id: 8, title: "SpaceX successfully launches another batch of Starlink satellites", source: "space.com", time: "3h"),
        ArticleItem(id: 9, title: "Understanding the basics of Quantum Computing", source: "mit.edu", time: "7h"),
        ArticleItem(id: 10, title: "10 Hidden Gems in Europe You Must Visit", source: "lonelyplanet.com", time: "9h")
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // Split items into two columns for masonry layout
    var leftColumnItems: [ArticleItem] {
        items.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }
    }
    
    var rightColumnItems: [ArticleItem] {
        items.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                TodayHeaderView()
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                
                VStack(spacing: 24) {
                    // Featured Card
                    FeaturedCard()
                        .frame(height: 400)
                    
                    // Masonry Grid
                    HStack(alignment: .top, spacing: 16) {
                        // Left Column
                        LazyVStack(spacing: 24) {
                            ForEach(leftColumnItems) { item in
                                GridCard(item: item)
                            }
                        }
                        
                        // Right Column
                        LazyVStack(spacing: 24) {
                            ForEach(rightColumnItems) { item in
                                GridCard(item: item)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onScrollGeometryChange(for: Double.self) { geometry in
            let contentHeight = geometry.contentSize.height
            let visibleHeight = geometry.containerSize.height
            let offset = geometry.contentOffset.y
            let maxOffset = contentHeight - visibleHeight
            if maxOffset > 0 {
                return max(0, min(1, offset / maxOffset))
            }
            return 0.0
        } action: { oldValue, newValue in
            scrollProgress = newValue
        }
    }
}

struct TodayPage_Previews: PreviewProvider {
    static var previews: some View {
        TodayPage(scrollProgress: .constant(0.0))
    }
}

