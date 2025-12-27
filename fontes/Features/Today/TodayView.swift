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
    var filteredContent: (featured: ReadingItem?, list: [ReadingItem]) {
        let allItems = [MockData.shared.featuredItem] + MockData.shared.items
        
        let filtered: [ReadingItem]
        
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
    var featuredItem: ReadingItem? {
        filteredContent.featured
    }
    
    // Sample data for the grid
    var items: [ReadingItem] {
        filteredContent.list
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // Split items into two columns for masonry layout
    var leftColumnItems: [ReadingItem] {
        items.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }
    }
    
    var rightColumnItems: [ReadingItem] {
        items.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    TodayHeaderView()
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    
                    VStack(spacing: 24) {
                        // Featured Card
                        if let featuredItem = featuredItem {
                            NavigationLink(value: featuredItem) {
                                FeaturedCard(item: featuredItem)
                                    .frame(height: 400)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Masonry Grid
                        HStack(alignment: .top, spacing: 16) {
                            // Left Column
                            LazyVStack(spacing: 24) {
                                ForEach(leftColumnItems) { item in
                                    NavigationLink(value: item) {
                                        GridCard(item: item)
                                            .transition(.scale.combined(with: .opacity))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                            // Right Column
                            LazyVStack(spacing: 24) {
                                ForEach(rightColumnItems) { item in
                                    NavigationLink(value: item) {
                                        GridCard(item: item)
                                            .transition(.scale.combined(with: .opacity))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .animation(.default, value: items.map { $0.id })
                    .animation(.default, value: featuredItem?.id)
                }
            }
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
            .navigationDestination(for: ReadingItem.self) { item in
                ReadingDetailView(item: item)
            }
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

