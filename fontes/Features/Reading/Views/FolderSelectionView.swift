//
//  FolderSelectionView.swift
//  fontes
//
//  Created by Mateus Costa on 14/01/2026.
//

import SwiftUI

struct FolderSelectionView: View {
    let item: ReadingItem
    @ObservedObject var feedStore = FeedStore.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var newFolderName = ""
    @State private var showingNewFolderInput = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Select Folder") {
                    ForEach(feedStore.savedFolders) { folder in
                        HStack {
                            Image(systemName: folder.iconName)
                                .foregroundColor(.blue)
                            Text(folder.name)
                            Spacer()
                            if folder.itemIDs.contains(item.id) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleFolder(folder)
                        }
                    }
                }
                
                if showingNewFolderInput {
                    Section {
                        HStack {
                            TextField("New Folder Name", text: $newFolderName)
                                .onSubmit {
                                    createNewFolder()
                                }
                            
                            Button("Create") {
                                createNewFolder()
                            }
                            .disabled(newFolderName.isEmpty)
                        }
                    }
                } else {
                    Button(action: {
                        withAnimation {
                            showingNewFolderInput = true
                        }
                    }) {
                        Label("Create New Folder", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Save to...")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private func toggleFolder(_ folder: SavedFolder) {
        if folder.itemIDs.contains(item.id) {
            feedStore.removeFromFolder(folder, item: item)
        } else {
            feedStore.addToFolder(folder, item: item)
        }
    }
    
    private func createNewFolder() {
        guard !newFolderName.isEmpty else { return }
        feedStore.createFolder(name: newFolderName)
        
        // Auto-add to the new folder
        if let newFolder = feedStore.savedFolders.last {
            feedStore.addToFolder(newFolder, item: item)
        }
        
        newFolderName = ""
        showingNewFolderInput = false
    }
}
