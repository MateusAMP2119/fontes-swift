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
    var onAddFolder: (String) -> Void
    var isMinimized: Bool = false
    @Namespace private var transition
    
    @State private var showExpansion = false
    
    var body: some View {
        HStack(spacing: 8) {
            // Folder Selection Pill
            Button {
                showExpansion = true
            } label: {
                HStack(spacing: 6) {
                    HStack(spacing: 12) {
                        Image(systemName: "folder")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(selectedFolder ?? "Guardados")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .lineLimit(1)
                    }
                        .padding(.horizontal)
                    
                    Rectangle()
                        .frame(width: 1)
                        .padding(.vertical, 6)
                    
                    Image(systemName: "square.and.pencil")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                }
                .padding(.horizontal, 12)
                .frame(height: 32)
                .background(Color.primary.opacity(0.05))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(Color.gray, lineWidth: 0)
                )
            }
            .matchedTransitionSource(
                id: "expansion", in: transition
            )
            .tint(.primary)
            
            // Edit Button removed (merged into pill)
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showExpansion) {
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
            .presentationDetents([.medium, .large])
            .navigationTransition(
                .zoom(sourceID: "expansion", in: transition)
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
                    onAddFolder: { name in
                        folders.append(name)
                    }
                )
                
                TabAccessoryFolderPicker(
                    selectedFolder: $selectedFolder,
                    folders: $folders,
                    onAddFolder: { _ in },
                    isMinimized: true
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
