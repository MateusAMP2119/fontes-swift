//
//  GridCard.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct GridCard: View {
    let item: ReadingItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Article Image
            Group {
                if let imageURLString = item.imageURL, let imageURL = URL(string: imageURLString) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(item.mainColor.opacity(0.3))
                                .overlay {
                                    ProgressView()
                                }
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Rectangle()
                                .fill(item.mainColor)
                        @unknown default:
                            Rectangle()
                                .fill(item.mainColor)
                        }
                    }
                } else {
                    // Fallback color placeholder when no image URL
                    Rectangle()
                        .fill(item.mainColor)
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            // Text Content
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        if let url = URL(string: item.sourceLogo) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(height: 32)
                        }
                        
                        Spacer()
                    }
                    
                    Text(item.title)
                        .font(.system(size: 16, weight: .bold))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.primary)
                    
                    Text("\(item.author) • \(item.time)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if !item.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                ForEach(item.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption2)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                }
                
                ArticleActionMenu(
                    onSave: { print("Saved \(item.title)") },
                    onMoreLikeThis: { print("More like This: \(item.title)") },
                    onBuildAlgorithm: { print("Build algo: \(item.title)") },
                    showBackground: false,
                    menuId: "\(item.id)"
                )
            }
        }
    }
}
