//
//  ShortcutMenuView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct ShortcutMenuView: View {
    var title: String
    
    var body: some View {
        HStack {
            Menu {
                Button {
                    print("Rename tapped")
                } label: {
                    Label("Rename", systemImage: "pencil")
                }
                
                Button {
                    print("Choose Icon tapped")
                } label: {
                    Label("Choose Icon", systemImage: "square.dashed")
                }
                
                Button {
                    print("Duplicate tapped")
                } label: {
                    Label("Duplicate", systemImage: "plus.square.on.square")
                }
                
                Button {
                    print("Move tapped")
                } label: {
                    Label("Move", systemImage: "folder")
                }
                
                Divider()
                
                Button {
                    print("Add to Home Screen tapped")
                } label: {
                    Label("Add to Home Screen", systemImage: "plus.app")
                }
            } label: {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Image(systemName: "chevron.down.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                        .font(.system(size: 20))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ShortcutMenuView(title: "New Shortcut")
}
