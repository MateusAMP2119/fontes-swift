//
//  TodayPage.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct TodayPage: View {
    @Binding var scrollProgress: Double
    
    // Filter State
    var selectedTags: Set<String>
    var selectedJournalists: Set<String>
    var selectedSources: Set<String>
    
    // Unified data access to handle dynamic filtering
    var filteredContent: (featured: ArticleItem?, list: [ArticleItem]) {
        let allItems = [MockData.shared.featuredItem] + MockData.shared.items
        
        let filtered: [ArticleItem]
        
        if selectedTags.isEmpty && selectedJournalists.isEmpty && selectedSources.isEmpty {
            filtered = allItems
        } else {
            filtered = allItems.filter { item in
                let matchesTags = selectedTags.isEmpty || !selectedTags.isDisjoint(with: Set(item.tags))
                let matchesJournalist = selectedJournalists.isEmpty || selectedJournalists.contains(item.author)
                let matchesSource = selectedSources.isEmpty || selectedSources.contains(item.source)
                
                return matchesTags && matchesJournalist && matchesSource
            }
        }
        
        if let first = filtered.first {
            return (first, Array(filtered.dropFirst()))
        } else {
            return (nil, [])
        }
    }
    
    // Featured item
    var featuredItem: ArticleItem? {
        filteredContent.featured
    }
    
    // Sample data for the grid
    var items: [ArticleItem] {
        filteredContent.list
    }
    
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
                    if let featuredItem = featuredItem {
                        FeaturedCard(item: featuredItem)
                            .frame(height: 400)
                    }
                    
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
        TodayPage(
            scrollProgress: .constant(0.0),
            selectedTags: [],
            selectedJournalists: [],
            selectedSources: []
        )
    }
}

