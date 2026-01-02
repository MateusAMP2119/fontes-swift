//
//  DiscoverView.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct DiscoverView: View {
    @Binding var scrollProgress: Double
    @State var search: String = ""

    let topics: [TopicData] = [
        TopicData(rank: 1, title: "Coronavirus (COVID-19)", trend: .up, change: "15%"),
        TopicData(rank: 2, title: "Health (India)", trend: .down, change: "8%"),
        TopicData(rank: 3, title: "World Politics", trend: .stable, change: "0%"),
        TopicData(rank: 4, title: "Technology Trends", trend: .up, change: "12%"),
        TopicData(rank: 5, title: "Climate Change", trend: .stable, change: "1%")
    ]


    // Static data to ensure stable IDs during view updates
    static let stableTopResult = DiscoverArticle(
        imageName: "virus_icon",
        title: "Coronavirus COVID-19",
        subtitle: "By euronews en español",
        details: "5,944 viewers • 4,968 stories",
        isFollowing: true,
        color: .blue
    )
    
    static let stableMagazines = [
        DiscoverArticle(
            imageName: "vaccine_icon",
            title: "The Latest on Coronavirus...",
            subtitle: "By The News Desk",
            details: "1.2M viewers • 11,293 stories",
            isFollowing: false,
            color: .orange
        ),
        DiscoverArticle(
            imageName: "flag_icon",
            title: "Coronavirus: COVID-19",
            subtitle: "By CaliGypsyGurl",
            details: "1.2M viewers • 11,293 stories",
            isFollowing: false,
            color: .green
        )
    ]
    
    let topResult = DiscoverView.stableTopResult
    let magazines = DiscoverView.stableMagazines

    @State private var activeMenuId: String? = nil
    @State private var selectedArticle: DiscoverArticle?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    TodayHeaderView()
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    
                    // Top Result
                    VStack(alignment: .leading, spacing: 12) {
                        Text("TOP RESULT")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Button {
                            selectedArticle = topResult
                        } label: {
                            DiscoverResultRow(
                                imageName: topResult.imageName,
                                title: topResult.title,
                                subtitle: topResult.subtitle,
                                details: topResult.details,
                                isFollowing: topResult.isFollowing,
                                color: topResult.color
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Topics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("TOPICS")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        ForEach(topics) { topic in
                            DiscoverTopicRow(rank: topic.rank, title: topic.title, trend: topic.trend, change: topic.change)
                        }
                        
                        Button(action: {
                            // Action for see more
                        }) {
                            Text("See more")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .fontWeight(.medium)
                        }
                        .padding(.leading, 40) // Align with title (24 rank width + 16 spacing)
                    }
                    
                    // Sources
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SOURCES")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.purple)
                                .frame(width: 50, height: 50)
                                .overlay(Image(systemName: "map").foregroundColor(.white)) // Placeholder
                            
                            Text("COVID-19 Visualized Through Charts")
                                .font(.headline)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    // Magazines
                    VStack(alignment: .leading, spacing: 12) {
                        Text("MAGAZINES")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        ForEach(magazines) { magazine in
                            Button {
                                selectedArticle = magazine
                            } label: {
                                DiscoverResultRow(
                                    imageName: magazine.imageName,
                                    title: magazine.title,
                                    subtitle: magazine.subtitle,
                                    details: magazine.details,
                                    isFollowing: magazine.isFollowing,
                                    color: magazine.color
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.bottom)
                .searchable(
                                text: $search,
                                placement: .toolbar, // Integrates with the glass navigation bar
                                prompt: "Type here to search"
                            )
            }
            .simultaneousGesture(
                DragGesture().onChanged { _ in
                    if activeMenuId != nil {
                        withAnimation {
                            activeMenuId = nil
                        }
                    }
                }
            )
            .environment(\.activeMenuId, $activeMenuId)
            .onScrollGeometryChange(for: Double.self) { geometry in
                let contentHeight = geometry.contentSize.height
                let visibleHeight = geometry.containerSize.height
                let offset = geometry.contentOffset.y
                let maxOffset = contentHeight - visibleHeight
                if maxOffset > 0 {
                    return Double(max(0, min(1, offset / maxOffset)))
                }
                return 0.0
            } action: { oldValue, newValue in
                scrollProgress = newValue
            }
            .fullScreenCover(item: $selectedArticle) { article in
                // Determine next item
                let nextItem: ReadingItem? = {
                    // Flatten list: Top Result + Magazines
                    var allArticles = [topResult]
                    allArticles.append(contentsOf: magazines)
                    
                    if let index = allArticles.firstIndex(where: { $0.id == article.id }),
                       index + 1 < allArticles.count {
                        return allArticles[index + 1].asReadingItem
                    }
                    return nil
                }()
                
                ReadingDetailView(
                    item: article.asReadingItem,
                    nextItem: nextItem,
                    onNext: { nextReadingItem in
                        // Find the corresponding DiscoverArticle to update the selection
                        // This assumes we can find it by ID or matching properties. 
                        // Since 'next' comes from our list, we can search our list again.
                        var allArticles = [topResult]
                        allArticles.append(contentsOf: magazines)
                        
                        if let match = allArticles.first(where: { $0.asReadingItem.id == nextReadingItem.id }) {
                            selectedArticle = match
                        }
                    }
                )
            }
        }
    }
}

#Preview {
    DiscoverView(scrollProgress: .constant(0.0))
}
