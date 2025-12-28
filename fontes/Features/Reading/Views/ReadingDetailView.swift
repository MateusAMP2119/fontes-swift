//
//  ReadingDetailView.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import SwiftUI

struct ReadingDetailView: View {
    let item: ReadingItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // MARK: - Content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    Text(item.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    
                    // Author and Timestamp (Top)
                    HStack(spacing: 4) {
                        Text(item.author.isEmpty ? "Author Name" : item.author)
                            .fontWeight(.medium)
                        Text("·")
                        Text(item.time.isEmpty ? "Date" : item.time)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, -8)
                    
                    // Tags
                    if !item.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(item.tags, id: \.self) { tag in
                                    Text(tag.uppercased())
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.secondary.opacity(0.2)) // Adapted for light/dark mode
                                        .cornerRadius(4)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(.bottom, 8) // Adjust padding to separate from Subtitle
                    }
                    
                    // Subtitle (Placeholder)
                    Text("With schools closed, Lahaina parents left children at home while they worked; confirmed death toll of 110 is expected to rise")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                    
                    // Featured Image (Placeholder)
                    // Using a gray rectangle as placeholder if no reliable URL
                    ZStack(alignment: .topLeading) {
                        if let url = URL(string: "https://picsum.photos/800/600") { // Placeholder URL
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().scaledToFit()
                                case .failure:
                                    Color.gray.frame(height: 250)
                                case .empty:
                                    Color.gray.frame(height: 250)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .clipped()
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 250)
                        }
                        
                        // Source Logo Overlay
                        if let logoUrl = URL(string: item.sourceLogo) {
                            AsyncImage(url: logoUrl) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Color.clear
                            }
                            .frame(height: 24)
                            .padding(8)
                            .glassEffect(in: .rect(cornerRadius: 8))
                            .padding(8)
                        }
                    }
                    
                    // Caption
                    Text("Displaced residents from Lahaina attend church services at King's Cathedral Maui in Kahului, Hawaii. Credit: JUSTIN SULLIVAN/GETTY IMAGES")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                    
                    // Body Text (Placeholder)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("This is an immersive reading view for the article titled \"\(item.title)\". In a real application, the full content of the article would be fetched and displayed here.")
                            .font(.system(size: 18))
                            .lineSpacing(6)
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")
                            .font(.system(size: 18))
                            .lineSpacing(6)
                        
                        Text("Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam.")
                            .font(.system(size: 18))
                            .lineSpacing(6)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 80)
                .padding(.top, 58)
            }
            
            // MARK: - Back button
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .frame(width: 40, height: 40)
                    .glassEffect(in: .circle)
            }
            .padding(.leading, 16)
            .padding(.top, 8)
        }
        .navigationBarHidden(true)
    }
}
