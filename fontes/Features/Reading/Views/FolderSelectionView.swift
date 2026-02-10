//
//  FolderSelectionView.swift
//  Fontes
//
//  Created by Mateus Costa on 14/01/2026.
//

import SwiftUI

struct FolderSelectionView: View {
    let item: ReadingItem
    @ObservedObject var feedStore = FeedStore.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    @State private var showingCreateFolder = false
    @State private var selectedFolderIDs: Set<UUID> = []

    var filteredFolders: [SavedFolder] {
        if searchText.isEmpty {
            return feedStore.savedFolders
        } else {
            return feedStore.savedFolders.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            if showingCreateFolder {
                CreateFolderView(
                    onCreate: { name, description, imageFilename in
                        createNewFolder(name: name, description: description, imageURL: imageFilename)
                        withAnimation {
                            showingCreateFolder = false
                        }
                    },
                    onCancel: {
                        withAnimation {
                            showingCreateFolder = false
                        }
                    }
                )
                .transition(.asymmetric(insertion: .scale(scale: 0.9).combined(with: .opacity), removal: .opacity))
                .zIndex(1)
            } else {
                VStack(spacing: 0) {
                    // Custom Header
                    HStack {
                        Text("Salvar na pasta")
                            .font(.title).bold()
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showingCreateFolder = true
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "plus")
                                Text("Criar")
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                        }
                        .glassEffect(.regular.tint(.red).interactive())
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.gray)
                            .frame(width: 32, height: 32)
                        }
                        .glassEffect(.regular.interactive())
                        .clipShape(Circle())
                    }
                    .padding(.horizontal, 26)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        
                        TextField("Pesquisar pasta...", text: $searchText)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    
                    // List
                    List {
                        ForEach(filteredFolders) { folder in
                            FolderRow(folder: folder, isSelected: selectedFolderIDs.contains(folder.id))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    toggleFolder(folder)
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
                    // Save Button
                    Button(action: {
                        saveChanges()
                    }) {
                        Text("Guardar")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                    }
                    .glassEffect(.regular.tint(.red).interactive())
                    .disabled(selectedFolderIDs.isEmpty)
                    .opacity(selectedFolderIDs.isEmpty ? 0.5 : 1.0)
                }
                .background(Color.white)
                .transition(.opacity)
                .zIndex(0)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
        .onAppear {
            initializeSelection()
        }
    }
    
    private func initializeSelection() {
        // Initialize with empty selection by default
        selectedFolderIDs = []
    }
    
    private func toggleFolder(_ folder: SavedFolder) {
        if selectedFolderIDs.contains(folder.id) {
            selectedFolderIDs.remove(folder.id)
        } else {
            selectedFolderIDs.insert(folder.id)
        }
    }
    
    private func createNewFolder(name: String, description: String?, imageURL: String?) {
        feedStore.createFolder(name: name, imageURL: imageURL, description: description)
        
        // Auto-select the new folder locally
        if let newFolder = feedStore.savedFolders.last {
            selectedFolderIDs.insert(newFolder.id)
        }
    }
    
    private func saveChanges() {
        // Only ADD to selected folders. Do not remove from folders not selected,
        // because we start with an empty selection state.
        for folder in feedStore.savedFolders {
            let isSelected = selectedFolderIDs.contains(folder.id)
            let isAlreadySaved = folder.itemIDs.contains(item.id)
            
            if isSelected && !isAlreadySaved {
                feedStore.addToFolder(folder, item: item)
            }
        }
        dismiss()
    }
}

struct FolderRow: View {
    let folder: SavedFolder
    let isSelected: Bool
    
    // Construct a Feed object to leverage FeedIconCollage
    // This is a visual representation only
    private var feedRepresentation: Feed {
        // Derive sources from the items in the folder?
        // Since we only have IDs, we can't easily get sources here without querying the store.
        // However, FeedIconCollage takes a Feed.
        // We can create a Feed with sources derived from folder content if available,
        // or just use generic/empty for now if we want to rely on folder.imageURL primarily.
        
        // If the folder has an imageURL, FeedIconCollage will use it (Feed.imageURL).
        // If not, it falls back to sources or icon.
        
        var sources: [String] = []
        
        // Optional: Attempt to get a few sources from the items in this folder to populate the collage
        let validItems = FeedStore.shared.items.filter { folder.itemIDs.contains($0.id) }
        let distinctSources = Array(Set(validItems.map { $0.source })).prefix(4).map { String($0) }
        sources = distinctSources
        
        return Feed(
            id: folder.id,
            name: folder.name,
            description: folder.description,
            iconName: folder.iconName,
            colorHex: "#FF0000", // Using Red as requested
            imageURL: folder.imageURL,
            sources: sources,
            isDefault: false
        )
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Container
            FeedIconCollage(feed: feedRepresentation, size: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(folder.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                HStack(spacing: 4) {
                    Text("\(folder.itemIDs.count) itens")
                    if let description = folder.description {
                        Text("•")
                        Text(description)
                            .lineLimit(1)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.red) // Changed to Red
            } else {
                Image(systemName: "circle")
                    .font(.title2)
                    .foregroundStyle(.quaternary)
            }
        }
        .padding(.vertical, 4)
    }
}
