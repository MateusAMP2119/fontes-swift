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
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // "New Folder" Button
                Button(action: onAddFolder) {
                    if isMinimized {
                        Image(systemName: "plus")
                            .frame(height: 32)
                    } else {
                        HStack {
                            Image(systemName: "plus")
                            Text("New Folder")
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 32)
                    }
                }
                .buttonStyle(.bordered)
                .tint(.secondary)
                
                // All Item
                Button {
                    selectedFolder = nil
                } label: {
                     if isMinimized {
                        Image(systemName: "tray")
                             .foregroundColor(selectedFolder == nil ? .white : .primary)
                    } else {
                        Text("All")
                            .padding(.horizontal, 12)
                            .frame(height: 32)
                            .foregroundColor(selectedFolder == nil ? .white : .primary)
                    }
                }
                .background(selectedFolder == nil ? Color.black : Color.clear)
                .cornerRadius(16)
                // Existing Folders
                ForEach(folders, id: \.self) { folder in
                    Button {
                        selectedFolder = folder
                    } label: {
                        Text(folder)
                            .padding(.horizontal, 12)
                            .frame(height: 32)
                            .foregroundColor(selectedFolder == folder ? .white : .primary)
                            .background(selectedFolder == folder ? Color.black : Color.clear)
                            .cornerRadius(16)
                    }
                }
            }
        }
        .padding(.vertical)
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
