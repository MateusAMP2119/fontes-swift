//
//  MiniPlayerView.swift
//  fontes
//
//  Created by Mateus Costa on 17/12/2025.
//
import SwiftUI


struct PlayerItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let artist: String
    let artwork: String
}

struct MiniPlayerView: View {
    var selectedTab: TabBarView.TabIdentifier
    
    // For You
    @Binding var algorithms: [Algorithm]
    @Binding var selectedAlgorithmId: UUID?
    var onNewAlgorithm: () -> Void
    
    // Today
    @Binding var selectedTodayFilter: TodayFilter
    
    // For Later
    @Binding var folders: [Folder]
    @Binding var selectedFolderId: UUID?
    var onNewFolder: () -> Void
    
    @State private var currentID: UUID?
    
    let items: [PlayerItem] = [
        PlayerItem(title: "Starboy", artist: "The Weeknd", artwork: "current_artwork"),
        PlayerItem(title: "Midnight City", artist: "M83", artwork: "current_artwork"),
        PlayerItem(title: "Get Lucky", artist: "Daft Punk", artwork: "current_artwork")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Context Selector
                Group {
                    switch selectedTab {
                    case .today:
                        ContextSelectorPill(
                            icon: selectedTodayFilter.icon,
                            title: selectedTodayFilter.rawValue
                        ) {
                            ForEach(TodayFilter.allCases) { filter in
                                Button {
                                    withAnimation {
                                        selectedTodayFilter = filter
                                    }
                                } label: {
                                    if selectedTodayFilter == filter {
                                        Label(filter.rawValue, systemImage: "checkmark")
                                    } else {
                                        Label(filter.rawValue, systemImage: filter.icon)
                                    }
                                }
                            }
                        }
                        
                    case .forYou:
                        let currentAlgorithm = algorithms.first(where: { $0.id == selectedAlgorithmId }) 
                            ?? algorithms.first(where: { $0.isSelected }) 
                            ?? algorithms[0]
                            
                        ContextSelectorPill(
                            icon: currentAlgorithm.icon,
                            title: currentAlgorithm.name
                        ) {
                            Section("My Algorithms") {
                                ForEach(algorithms) { algo in
                                    Button {
                                        withAnimation {
                                            selectedAlgorithmId = algo.id
                                            for i in 0..<algorithms.count {
                                                algorithms[i].isSelected = (algorithms[i].id == algo.id)
                                            }
                                        }
                                    } label: {
                                        if selectedAlgorithmId == algo.id || (selectedAlgorithmId == nil && algo.isSelected) {
                                            Label(algo.name, systemImage: "checkmark")
                                        } else {
                                            Text(algo.name)
                                        }
                                    }
                                }
                            }
                            
                            Section {
                                Button(action: onNewAlgorithm) {
                                    Label("New Algorithm", systemImage: "plus")
                                }
                            }
                        }
                        
                    case .forLater:
                        let currentFolder = folders.first(where: { $0.id == selectedFolderId }) ?? folders[0]
                        
                        ContextSelectorPill(
                            icon: currentFolder.icon,
                            title: currentFolder.name
                        ) {
                            Section("My Folders") {
                                ForEach(folders) { folder in
                                    Button {
                                        withAnimation {
                                            selectedFolderId = folder.id
                                        }
                                    } label: {
                                        if selectedFolderId == folder.id {
                                            Label(folder.name, systemImage: "checkmark")
                                        } else {
                                            Label(folder.name, systemImage: folder.icon)
                                        }
                                    }
                                }
                            }
                            
                            Section {
                                Button(action: onNewFolder) {
                                    Label("New Folder", systemImage: "plus")
                                }
                            }
                        }
                        
                    case .search:
                        Color.clear
                    }
                }
                .frame(width: geometry.size.width * 0.35)
                .clipped()
                
                TabView(selection: $currentID) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        MiniPlayerRow(item: item, index: index + 1)
                            .tag(item.id as UUID?)
                            .padding(.horizontal)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(width: geometry.size.width * 0.65)
            }
        }
        .frame(height: 64)
        .onAppear {
            if currentID == nil {
                currentID = items.first?.id
            }
        }
    }
}

struct MiniPlayerRow: View {
    let item: PlayerItem
    let index: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // Artwork with the new adaptive glow effect
            HStack() {
                
                HStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .frame(width: 16, height: 16)
                        Text("\(index)")
                            .font(.system(size: 10, weight: .bold))
                    }
                    
                    Image(systemName: "play.fill")
                        .font(.system(size: 10, weight: .bold))
                }
                
                Image(item.artwork)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 15, weight: .semibold))
                
                Text(item.artist)
                    .font(.system(size: 13))
            }
            
            Spacer()
            
            // Interaction Group
            HStack(spacing: 20) {
                Button(action: { /* Play/Pause logic */ }) {
                    Image(systemName: "play.fill")
                        .font(.title3)
                }
                
                Button(action: { /* Skip logic */ }) {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                }
            }
        }
        .hoverEffect(.highlight)
    }
}
