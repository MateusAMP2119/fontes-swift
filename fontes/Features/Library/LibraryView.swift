//
//  LibraryView.swift
//  fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

struct LibraryView: View {
    @State private var feeds: [Feed] = [Feed.defaultFeed]
    @State private var searchText: String = ""
    @State private var sortOrder: SortOrder = .recent
    @State private var isGridView: Bool = false
    @State private var showingCreateFeed: Bool = false
    @State private var selectedFeed: Feed?
    
    enum SortOrder: String, CaseIterable {
        case recent = "Recents"
        case alphabetical = "Alphabetical"
        case creator = "Creator"
    }
    
    var filteredFeeds: [Feed] {
        var result = feeds
        
        // Filter by search
        if !searchText.isEmpty {
            result = result.filter { feed in
                feed.name.localizedCaseInsensitiveContains(searchText) ||
                feed.sources.contains { $0.localizedCaseInsensitiveContains(searchText) } ||
                feed.journalists.contains { $0.localizedCaseInsensitiveContains(searchText) } ||
                feed.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Sort
        switch sortOrder {
        case .recent:
            result.sort(by: { $0.updatedAt > $1.updatedAt })
        case .alphabetical:
            result.sort(by: { $0.name.localizedCompare($1.name) == .orderedAscending })
        case .creator:
            result.sort(by: { ($0.isDefault ? 0 : 1) < ($1.isDefault ? 0 : 1) })
        }
        
        // Pinned items first
        let pinned = result.filter { $0.isPinned }
        let unpinned = result.filter { !$0.isPinned }
        
        return pinned + unpinned
    }
    
    var body: some View {
        ScrollView {
            Spacer().frame(height: 44)

            VStack(spacing: 0) {
                // Sort Header
                sortHeader
                
                // Content
                if isGridView {
                    gridContent
                } else {
                    listContent
                }
            }
        }
        .onScrollHideHeader()
        .navigationTitle("Your Library")
        .searchable(text: $searchText, prompt: "Find in Your Library")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingCreateFeed = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateFeed) {
            CreateFeedView { newFeed in
                feeds.append(newFeed)
            }
        }
        .sheet(item: $selectedFeed) { feed in
            if let index = feeds.firstIndex(where: { $0.id == feed.id }) {
                FeedDetailView(feed: $feeds[index])
            }
        }
    }
    
    // MARK: - Sort Header
    private var sortHeader: some View {
        HStack {
            // Sort menu
            Menu {
                ForEach(SortOrder.allCases, id: \.self) { order in
                    Button {
                        sortOrder = order
                    } label: {
                        HStack {
                            Text(order.rawValue)
                            if sortOrder == order {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.caption)
                    Text(sortOrder.rawValue)
                        .font(.subheadline)
                }
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // View toggle
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isGridView.toggle()
                }
            } label: {
                Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    // MARK: - List Content
    private var listContent: some View {
        LazyVStack(spacing: 0) {
            ForEach(filteredFeeds) { feed in
                LibraryFeedRow(feed: feed) {
                    selectedFeed = feed
                }
            }
        }
    }
    
    // MARK: - Grid Content
    private var gridContent: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 100), spacing: 16)],
            spacing: 16
        ) {
            ForEach(filteredFeeds) { feed in
                LibraryFeedGridItem(feed: feed) {
                    selectedFeed = feed
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
}
