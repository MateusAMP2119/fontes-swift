//
//  MiniPlayerView.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct MiniPlayerView: View {
    @ObservedObject private var store = FeedStore.shared
    
    var body: some View {
        HStack(spacing: 12) {
            // Leading Image
            if let item = displayedItem {
                // Try article image first, then source logo, then placeholder
                AsyncImage(url: URL(string: item.imageURL ?? item.sourceLogo)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill) // Fill for better visual
                    } else if phase.error != nil {
                        Color.gray // Fallback
                    } else {
                        Color.gray.opacity(0.2) // Placeholder
                    }
                }
                .frame(width: 32, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                // Top Text
                Text(headerText)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                
                // Bottom Text (Title)
                if let item = displayedItem {
                    Text(item.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
        }
        
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            if let item = displayedItem {
                onTap?(item)
            }
        }
    }
    
    var onTap: ((ReadingItem) -> Void)? = nil
    
    private var displayedItem: ReadingItem? {
        store.lastReadItem ?? store.featuredItem
    }
    
    private var headerText: String {
        store.lastReadItem != nil ? "Mais prespectivas" : "Começa por aqui"
    }
}

#Preview {
    MiniPlayerView()
        .padding()
        .background(Color.white)
}
