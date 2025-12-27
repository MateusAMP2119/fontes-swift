//
//  FolderExpansion.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import SwiftUI

struct FolderExpansion: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedFolder: String?
    @Binding var folders: [String]
    var onAddFolder: () -> Void
    var onDeleteFolder: (IndexSet) -> Void
    var onMoveFolder: (IndexSet, Int) -> Void
    
    @State private var isEditing = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                }
                
                Spacer()
                
                Text("Folders")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Edit Button
                Button(action: {
                    withAnimation {
                        isEditing.toggle()
                    }
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                }
            }
            .padding()
            .padding(.top, 10)
            
            // Content
            List {
                Section {
                    Button {
                        selectedFolder = nil
                        dismiss()
                    } label: {
                        HStack {
                            Label("All", systemImage: "tray")
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedFolder == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Section("My Folders") {
                    ForEach(folders, id: \.self) { folder in
                        Button {
                            if !isEditing {
                                selectedFolder = folder
                                dismiss()
                            }
                        } label: {
                            HStack {
                                Label(folder, systemImage: "folder")
                                    .foregroundColor(.primary)
                                Spacer()
                                if !isEditing && selectedFolder == folder {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    .onDelete(perform: onDeleteFolder)
                    .onMove(perform: onMoveFolder)
                }
                
                if isEditing {
                    Section {
                        Button(action: onAddFolder) {
                            Label("Add New Folder", systemImage: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .environment(\.editMode, .constant(isEditing ? .active : .inactive))
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    FolderExpansion(
        selectedFolder: .constant(nil),
        folders: .constant(["Tech", "Design", "Recipes"]),
        onAddFolder: {},
        onDeleteFolder: { _ in },
        onMoveFolder: { _, _ in }
    )
}
