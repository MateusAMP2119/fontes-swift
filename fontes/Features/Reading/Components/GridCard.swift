//
//  GridCard.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct GridCard: View {
    let item: ReadingItem
    @ObservedObject var feedStore = FeedStore.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Article Image
            // Article Image
            GeometryReader { geometry in
                Group {
                    if let imageURLString = item.imageURL, let imageURL = URL(string: imageURLString) {
                        CachedAsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(item.mainColor.opacity(0.3))
                                .overlay {
                                    ProgressView()
                                }
                        }
                    } else {
                        // Fallback color placeholder when no image URL
                        Rectangle()
                            .fill(item.mainColor)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
            }
            .frame(height: 140)
            .overlay(alignment: .topTrailing) {
                Button {
                    feedStore.toggleSaved(item)
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                } label: {
                    Image(systemName: feedStore.isSaved(item) ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .symbolEffect(.bounce, value: feedStore.isSaved(item))
                        .frame(width: 32, height: 32)
                        .background(.black.opacity(0.4))
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            // Text Content
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    if let url = URL(string: item.sourceLogo) {
                        CachedAsyncImage(url: url) { image in
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
        }
    }
}
