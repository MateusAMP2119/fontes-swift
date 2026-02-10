//
//  LibraryView.swift
//  Fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var feedStore = FeedStore.shared
    @State private var searchText: String = ""
    @State private var showingCreateFeed: Bool = false
    @State private var selectedFeed: Feed?
    
    enum TabSelection: String, CaseIterable {
        case feeds = "Feeds"
        case folders = "Pastas"
    }
    
    @State private var selectedTab: TabSelection = .feeds
    
    // Create feed/folder state
    @State private var showingCreateOptions = false
    @State private var showingCreateFolder = false
    @State private var newFolderName = ""
    
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
        
        // Pinned items first, then alphabetical
        result.sort {
            if $0.isPinned != $1.isPinned {
                return $0.isPinned
            }
            return $0.name.localizedCompare($1.name) == .orderedAscending
        }
        
        return result
    }
    
    var filteredFolders: [SavedFolder] {
        var result = feedStore.savedFolders
        
        if !searchText.isEmpty {
            result = result.filter { folder in
                folder.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            headerView
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Pesquisar na biblioteca", text: $searchText)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            // Chips
            HStack(spacing: 12) {
                ForEach(TabSelection.allCases, id: \.self) { tab in
                    FilterChip(
                        text: tab.rawValue,
                        isSelected: selectedTab == tab,
                        action: { selectedTab = tab }
                    )
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            // Content List
            List {
                switch selectedTab {
                case .feeds:
                    feedsSection
                case .folders:
                    foldersSection
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .background(Color.white)
        .toolbar(.hidden, for: .navigationBar) // Hide default navigation bar
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
        .sheet(isPresented: $showingCreateOptions) {
            createOptionsSheet
                .presentationDetents([.fraction(0.25)])
                .presentationDragIndicator(.visible)
        }
        .alert("Nova Pasta", isPresented: $showingCreateFolder) {
            TextField("Nome da Pasta", text: $newFolderName)
            Button("Cancelar", role: .cancel) { }
            Button("Criar") {
                if !newFolderName.isEmpty {
                    feedStore.createFolder(name: newFolderName)
                    newFolderName = ""
                    // Switch to folders tab to see the new folder
                    selectedTab = .folders
                }
            }
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            Text("Biblioteca")
                .font(.title).bold()
            
            Spacer()
            
            Button(action: {
                showingCreateOptions = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 40, height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 26)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
    
    // MARK: - Feeds Section
    @ViewBuilder
    private var feedsSection: some View {
        if filteredFeeds.isEmpty {
            emptyStateView(
                icon: "newspaper",
                title: "Nenhum feed encontrado",
                message: "Toque em + para criar o seu primeiro feed."
            )
            .listRowSeparator(.hidden)
        } else {
            ForEach(filteredFeeds) { feed in
                LibraryFeedRow(feed: feed) {
                    selectedFeed = feed
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
                .listRowSeparator(.hidden)
            }
        }
    }
    
    // MARK: - Folders Section
    @ViewBuilder
    private var foldersSection: some View {
        if filteredFolders.isEmpty {
            emptyStateView(
                icon: "folder",
                title: "Nenhuma pasta encontrada",
                message: "Organize os seus items guardados em pastas."
            )
            .listRowSeparator(.hidden)
        } else {
            ForEach(feedStore.savedFolders) { folder in
                HStack(spacing: 16) {
                    // Start of Folder Row Design
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "folder.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(folder.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Text("\(folder.itemIDs.count) items")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color(.tertiaryLabel))
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())
                // Basic tap action logic for folders - placeholder for now
                .onTapGesture {
                    // Navigate to folder detail or expand
                    // For now just print
                    print("Tapped folder: \(folder.name)")
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
                .listRowSeparator(.hidden)
            }
        }
    }
    
    private func emptyStateView(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 48)
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.secondary.opacity(0.5))
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    // MARK: - Create Options Sheet
    private var createOptionsSheet: some View {
        VStack(spacing: 0) {
            Text("Criar Novo")
                .font(.headline)
                .padding(.top, 24)
                .padding(.bottom, 24)
            
            Divider()
            
            Button {
                showingCreateOptions = false
                showingCreateFeed = true
            } label: {
                HStack {
                    Image(systemName: "newspaper")
                        .frame(width: 24)
                    Text("Novo Feed")
                    Spacer()
                }
                .padding()
                .foregroundStyle(.primary)
            }

            Divider()
            
            Button {
                showingCreateOptions = false
                newFolderName = ""
                showingCreateFolder = true
            } label: {
                HStack {
                    Image(systemName: "folder.badge.plus")
                        .frame(width: 24)
                    Text("Nova Pasta")
                    Spacer()
                }
                .padding()
                .foregroundStyle(.primary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
}
