//
//  GridCard.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct GridCard: View {
    let item: ArticleItem
    
    // Generate a consistent color based on index
    var cardColor: Color {
        let colors: [Color] = [.orange, .purple, .pink, .green, .yellow, .indigo]
        return colors[item.id % colors.count]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image placeholder
            GeometryReader { geometry in
                if item.id % 2 == 0 {
                    // Split view style for even items (mimicking the left card in grid)
                    HStack(spacing: 2) {
                        VStack(spacing: 2) {
                            Rectangle().fill(cardColor.opacity(0.8))
                            Rectangle().fill(cardColor.opacity(0.6))
                        }
                        Rectangle().fill(cardColor)
                    }
                } else {
                    // Single image style
                    Rectangle()
                        .fill(cardColor)
                }
            }
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            // Text Content
            VStack(alignment: .leading, spacing: 6) {
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
