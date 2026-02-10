//
//  FeaturedCard.swift
//  Fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct FeaturedCard: View {
    let item: ReadingItem
    @ObservedObject var feedStore = FeedStore.shared
    
    var body: some View {
            ZStack(alignment: .bottomLeading) {
                // Article Image or fallback gradient
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
                                            .tint(.white)
                                    }
                            }
                        } else {
                            // Fallback gradient when no image URL
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [item.mainColor, item.mainColor.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                }
                // Dark gradient overlay for text readability
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Action Menu

                
                // Content Overlay
                VStack(alignment: .leading, spacing: 8) {
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
                    
                    Text(item.title)
                        .font(.system(size: 28, weight: .bold)) // Large title
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .lineLimit(3)
                    
                    HStack {
                        Text(item.author)
                        Text("•")
                        Text(item.time)
                    }
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(radius: 2)
                    
                    // Tags and Action Row
                    HStack(alignment: .bottom, spacing: 12) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(item.tags, id: \.self) { tag in
                                        Text(tag.uppercased())
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.black.opacity(0.3))
                                            .cornerRadius(4)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        Spacer()

                    }
                }
                .padding(20)
                
                // Save Button (Top Right)
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            feedStore.toggleSaved(item)
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                        } label: {
                            Image(systemName: feedStore.isSaved(item) ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .symbolEffect(.bounce, value: feedStore.isSaved(item))
                                .frame(width: 48, height: 48)
                                .background(.black.opacity(0.4))
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Spacer()
                }
                

            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
            

    }
}
