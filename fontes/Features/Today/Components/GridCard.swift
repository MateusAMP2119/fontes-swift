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
                Text(item.title)
                    .font(.system(size: 16, weight: .bold))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.primary)
                
                HStack {
                    Text("\(item.source) • \(item.time)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
