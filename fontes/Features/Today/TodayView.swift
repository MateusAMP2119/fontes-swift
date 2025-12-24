//
//  TodayPage.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct ArticleItem: Identifiable {
    let id: Int
    let title: String
    let source: String
    let time: String
}

struct TodayPage: View {
    // Sample data for the grid
    let items: [ArticleItem] = [
        ArticleItem(id: 1, title: "'I annoyed him a lot - I think that's why he was a little bit angry.", source: "dailymail.co.uk", time: "2h"),
        ArticleItem(id: 2, title: "Photoshop Troll Who Takes Photo Requests Too Literally Strikes Again, And The Result Is Hilarious", source: "boredpanda.com", time: "2h"),
        ArticleItem(id: 3, title: "New iPhone 16 Pro Max Review: The Best Just Got Better", source: "theverge.com", time: "4h"),
        ArticleItem(id: 4, title: "NASA's James Webb Space Telescope captures stunning new image of the Pillars of Creation", source: "nasa.gov", time: "8h"),
        ArticleItem(id: 5, title: "Why the future of renewable energy depends on this one critical mineral found in the deep ocean", source: "wired.com", time: "5h"),
        ArticleItem(id: 6, title: "Top 10 Places to Visit in Japan", source: "travelandleisure.com", time: "6h")
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
    }
}

struct FeaturedCard: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Main colorful background
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.teal, Color.blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            // Content Overlay
            VStack(alignment: .leading, spacing: 8) {
                Text("Apple's cheapest iPad may be the star of Apple's October event")
                    .font(.system(size: 28, weight: .bold)) // Large title
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                HStack {
                    Text("Macworld")
                        .fontWeight(.semibold)
                    Text("•")
                    Text("3h")
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .shadow(radius: 2)
            }
            .padding(20)
            
            // Top overlays
            VStack {
                HStack(alignment: .top) {
                    // Red Logo Box
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text("F")
                                .font(.system(size: 40, weight: .heavy))
                                .foregroundColor(.white)
                        )
                    
                    Spacer()
                    
                    // Settings Icon
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 20))
                        .padding(10)
                        .background(Color.black.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundColor(.white)
                        .padding(.top, 16)
                        .padding(.trailing, 16)
                }
                Spacer()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

struct GridCard: View {
    let item: ArticleItem
    
    // Generate a consistent color based on index
    var cardColor: Color {
        let colors: [Color] = [.orange, .purple, .pink, .green, .yellow, .indigo]
        return colors[item.id % colors.count]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image placeholder
            GeometryReader { geometry in
                if item.id % 2 == 0 {
                    // Split view style for even items (mimicking the left card in grid)
                    HStack(spacing: 2) {
                        VStack(spacing: 2) {
                            Rectangle().fill(cardColor.opacity(0.8))
                            Rectangle().fill(cardColor.opacity(0.6))
                        }
                        Rectangle().fill(cardColor)
                    }
                } else {
                    // Single image style
                    Rectangle()
                        .fill(cardColor)
                }
            }
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            // Text Content
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(size: 16, weight: .bold))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.primary)
                
                HStack {
                    Text("\(item.source) • \(item.time)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct TodayPage_Previews: PreviewProvider {
    static var previews: some View {
        TodayPage()
    }
}

