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
        ArticleItem(id: 1, title: "'I annoyed him a lot - I think that's why he was a little bit angry.", source: "dailymail.co.uk", time: "2h", author: "Sarah Jane", tags: ["Celebrity", "News"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824"),
        ArticleItem(id: 2, title: "Photoshop Troll Who Takes Photo Requests Too Literally Strikes Again, And The Result Is Hilarious", source: "boredpanda.com", time: "2h", author: "James Fridman", tags: ["Humor", "Viral"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043"),
        ArticleItem(id: 3, title: "New iPhone 16 Pro Max Review: The Best Just Got Better", source: "theverge.com", time: "4h", author: "Nilay Patel", tags: ["Tech", "Review"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.empregoestagios.com%2Fwp-content%2Fuploads%2F2022%2F02%2FObservador-660x330.png&f=1&nofb=1&ipt=6ce4e74a3dcc0cf828b8f6ae8283bbdcdfbeb71a6871e61fd5990a04c804a8b6"),
        ArticleItem(id: 4, title: "NASA's James Webb Space Telescope captures stunning new image of the Pillars of Creation", source: "nasa.gov", time: "8h", author: "Bill Nelson", tags: ["Space", "Science"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f"),
        ArticleItem(id: 5, title: "Why the future of renewable energy depends on this one critical mineral found in the deep ocean", source: "wired.com", time: "5h", author: "Matt Simon", tags: ["Environment", "Future"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824"),
        ArticleItem(id: 6, title: "Top 10 Places to Visit in Japan", source: "travelandleisure.com", time: "6h", author: "Stacey Leasca", tags: ["Travel", "Japan"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043"),
        ArticleItem(id: 7, title: "The Ultimate Guide to Homemade Pasta", source: "bonappetit.com", time: "1h", author: "Chris Morocco", tags: ["Food", "Cooking"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.empregoestagios.com%2Fwp-content%2Fuploads%2F2022%2F02%2FObservador-660x330.png&f=1&nofb=1&ipt=6ce4e74a3dcc0cf828b8f6ae8283bbdcdfbeb71a6871e61fd5990a04c804a8b6"),
        ArticleItem(id: 8, title: "SpaceX successfully launches another batch of Starlink satellites", source: "space.com", time: "3h", author: "Mike Wall", tags: ["SpaceX", "Tech"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f"),
        ArticleItem(id: 9, title: "Understanding the basics of Quantum Computing", source: "mit.edu", time: "7h", author: "Dr. Peter Shor", tags: ["Science", "Physics"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824"),
        ArticleItem(id: 10, title: "10 Hidden Gems in Europe You Must Visit", source: "lonelyplanet.com", time: "9h", author: "Tom Hall", tags: ["Travel", "Europe"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043")
    ]
    
    // Featured item
    let featuredItem = ArticleItem(
        id: 0,
        title: "Apple's cheapest iPad may be the star of Apple's October event",
        source: "Macworld",
        time: "3h",
        author: "Michael Simon",
        tags: ["Apple", "Tech", "Event"],
        sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f"
    )
    
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
                    FeaturedCard(item: featuredItem)
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

