//
//  LibraryView.swift
//  fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var feedStore = FeedStore.shared
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
        var result = feedStore.userFeeds
        
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
            .padding(.bottom, 32)
        }
        .onScrollHideHeader()
        .navigationTitle("Your Library")
        .searchable(text: $searchText, prompt: "Find in Your Library")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: { showingCreateFeed = true }) {
                        Label("New Feed", systemImage: "newspaper")
                    }
                    Button(action: { createNewFolder() }) {
                        Label("New Folder", systemImage: "folder.badge.plus")
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateFeed) {
            CreateFeedView { newFeed in
                feedStore.addUserFeed(newFeed)
            }
        }
        .sheet(item: $selectedFeed) { feed in
            if let index = feedStore.userFeeds.firstIndex(where: { $0.id == feed.id }) {
                FeedDetailView(feed: $feedStore.userFeeds[index])
            }
        }
        .alert("New Folder", isPresented: $showingCreateFolder) {
            TextField("Folder Name", text: $newFolderName)
            Button("Cancel", role: .cancel) { }
            Button("Create") {
                if !newFolderName.isEmpty {
                    feedStore.createFolder(name: newFolderName)
                    newFolderName = ""
                }
            }
        }
    }
    
    @State private var showingCreateFolder = false
    @State private var newFolderName = ""
    
    private func createNewFolder() {
        newFolderName = ""
        showingCreateFolder = true
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
        LazyVStack(spacing: 24, pinnedViews: [.sectionHeaders]) {
            // Section 1: Feeds
            if !filteredFeeds.isEmpty {
                Section {
                    ForEach(filteredFeeds) { feed in
                        LibraryFeedRow(feed: feed) {
                            selectedFeed = feed
                        }
                    }
                } header: {
                    sectionHeader("Feeds")
                }
            }
            
            // Section 2: Saved Folders
            if !feedStore.savedFolders.isEmpty {
                Section {
                    ForEach(feedStore.savedFolders) { folder in
                        // Placeholder row for folder
                        HStack {
                            Image(systemName: "folder.fill")
                                .foregroundStyle(.blue)
                                .font(.title2)
                            Text(folder.name)
                                .font(.headline)
                            Spacer()
                            Text("\(folder.itemIDs.count)")
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    }
                } header: {
                    sectionHeader("Saved Folders")
                }
            }
        }
    }
    
    // MARK: - Grid Content
    private var gridContent: some View {
        VStack(spacing: 24) {
            // Section 1: Feeds
            if !filteredFeeds.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    sectionHeader("Feeds")
                        .padding(.horizontal, 16)
                    
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
                }
            }
            
            // Section 2: Saved Folders
            if !feedStore.savedFolders.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    sectionHeader("Saved Folders")
                        .padding(.horizontal, 16)
                    
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 100), spacing: 16)],
                        spacing: 16
                    ) {
                        ForEach(feedStore.savedFolders) { folder in
                            // Placeholder grid item for folder
                            VStack {
                                Image(systemName: "folder.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.blue)
                                    .frame(height: 60)
                                Text(folder.name)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding(.top, 8)
    }
    
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
}
