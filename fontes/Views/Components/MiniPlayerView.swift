//
//  MiniPlayerView.swift
//  fontes
//
//  Created by Mateus Costa on 17/12/2025.
//
import SwiftUI

struct MiniPlayerView: View {
    var selectedTab: TabNavigationWrapper.TabIdentifier
    
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
                
                // Actions
                HStack(spacing: 16) {
                    Spacer()
                    
                    Button(action: {
                        // Action for summarizing
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                            Text("Sum up")
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.white.opacity(0.2), lineWidth: 0.5)
                        )
                    }
                    .foregroundStyle(.primary)
                    
                    Button(action: {
                        // Action for filtering
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(.white.opacity(0.2), lineWidth: 0.5)
                            )
                    }
                    .foregroundStyle(.primary)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.65)
            }
        }
        .frame(height: 64)
    }
}


