//
//  FeaturedCard.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct FeaturedCard: View {
    let item: ArticleItem
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Main colorful background
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.teal, Color.blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            // Content Overlay
            VStack(alignment: .leading, spacing: 8) {
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
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(4)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding(20)
            
            // Top overlays
            VStack {
                HStack(alignment: .top) {
                    // Red Logo Box
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text("F")
                                .font(.system(size: 40, weight: .heavy))
                                .foregroundColor(.white)
                        )
                    
                    Spacer()
                    
                    // Settings Icon
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 20))
                        .padding(10)
                        .background(Color.black.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundColor(.white)
                        .padding(.top, 16)
                        .padding(.trailing, 16)
                }
                Spacer()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
