//
//  TabAccessoryFolderPicker.swift
//  fontes
//
//  Created by Mateus Costa on 26/12/2025.
//

import SwiftUI

struct TabAccessoryFolderPicker: View {
    @Binding var selectedFolder: String?
    @Binding var folders: [String]
    var onAddFolder: () -> Void
    var isMinimized: Bool = false
    
    @State private var showExpansion = false
    
    var body: some View {
        HStack(spacing: 8) {
            // Folder Selection Pill
            Button {
                showExpansion = true
            } label: {
                HStack(spacing: 6) {
                    Text(selectedFolder ?? "All")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    
                    Image(systemName: "chevron.up")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 12)
                .frame(height: 32)
                .background(Color.primary.opacity(0.05))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                )
            }
            .tint(.primary)
            
            // Edit Button (opens expansion too)
            Button {
                showExpansion = true
            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.subheadline)
                    .frame(width: 32, height: 32)
                    .background(Color.primary.opacity(0.05))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                    )
            }
            .tint(.primary)
        }
        .padding(.vertical, 4)
        .fullScreenCover(isPresented: $showExpansion) {
            FolderExpansion(
                selectedFolder: $selectedFolder,
                folders: $folders,
                onAddFolder: onAddFolder,
                onDeleteFolder: { indexSet in
                    folders.remove(atOffsets: indexSet)
                },
                onMoveFolder: { indexSet, index in
                    folders.move(fromOffsets: indexSet, toOffset: index)
                }
            )
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var selectedFolder: String? = nil
        @State var folders = ["Tech", "Design", "Recipes"]
        
        var body: some View {
            VStack {
                TabAccessoryFolderPicker(
                    selectedFolder: $selectedFolder,
                    folders: $folders,
                    onAddFolder: {
                        folders.append("New Folder \(folders.count + 1)")
                    }
                )
                
                TabAccessoryFolderPicker(
                    selectedFolder: $selectedFolder,
                    folders: $folders,
                    onAddFolder: {},
                    isMinimized: true
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
