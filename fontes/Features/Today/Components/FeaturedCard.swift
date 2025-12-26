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
                    gradient: Gradient(colors: [item.mainColor, item.mainColor.opacity(0.8)]),
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
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
