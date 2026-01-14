//
//  NextArticleCard.swift
//  fontes
//
//  Created by Mateus Costa on 30/12/2025.
//

import SwiftUI

struct ReadingActions: View {
    let currentItem: ReadingItem
    let nextItem: ReadingItem
    let showHint: Bool
    
    @ObservedObject var feedStore = FeedStore.shared
    
    var body: some View {
        VStack(spacing: 12) {
            // Top Layer: Up Next (Aligned Right)
            HStack {
                Spacer()
                Button(action: {
                    // Next action
                }) {
                    HStack(spacing: 12) {
                        // Thumbnail (Main Color)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(nextItem.mainColor)
                            .frame(width: 44, height: 32)

                        VStack(alignment: .leading, spacing: 0) {
                            Text("UP NEXT")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            Text(nextItem.title)
                                .font(.system(size: 14, weight: .semibold))
                                .lineLimit(1)
                                .foregroundColor(.primary)
                        }
                        
                        Image(systemName: "chevron.forward")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(.regularMaterial)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
            }
            .padding(.horizontal, 16)
            
            // Bottom Layer: Back & Actions
            HStack(spacing: 12) {
                // Left: Back Button (Isolated)
                Button(action: {
                    // Back action handled by parent/env
                }) {
                    Image(systemName: "chevron.backward")
                        .frame(width: 44, height: 44)
                }
                .padding(8)
                .background(.regularMaterial)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Spacer()
                
                // Right: Save Action
                Menu {
                    // Saved Folders
                    ForEach(feedStore.savedFolders) { folder in
                        let isSavedInFolder = folder.itemIDs.contains(currentItem.id)
                        Button {
                            if isSavedInFolder {
                                feedStore.removeFromFolder(folder, item: currentItem)
                            } else {
                                feedStore.addToFolder(folder, item: currentItem)
                            }
                        } label: {
                            Label {
                                Text(folder.name)
                            } icon: {
                                Image(systemName: isSavedInFolder ? "checkmark" : folder.iconName)
                            }
                        }
                    }
                    
                    Divider()
                    
                    Button {
                        // Create Folder Action - In a real app this would trigger a sheet
                        // For now we just create a default "Read Later" if it doesn't exist
                        if !feedStore.savedFolders.contains(where: { $0.name == "Read Later" }) {
                            feedStore.createFolder(name: "Read Later")
                        }
                    } label: {
                        Label("New Folder", systemImage: "folder.badge.plus")
                    }
                    
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: feedStore.isSaved(currentItem) ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 20))
                        Text(feedStore.isSaved(currentItem) ? "Saved" : "Save")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.regularMaterial)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
            }
            .padding(.horizontal, 16)
        }
        .font(.system(size: 20))
        .foregroundColor(.primary)
    }
}
