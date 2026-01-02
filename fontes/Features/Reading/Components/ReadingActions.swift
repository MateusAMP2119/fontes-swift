//
//  NextArticleCard.swift
//  fontes
//
//  Created by Mateus Costa on 30/12/2025.
//

import SwiftUI

struct ReadingActions: View {
    let nextItem: ReadingItem
    let showHint: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Top Layer: Up Next (Aligned Right)
            HStack {
                Spacer()
                Button(action: {
                    // Next action
                }) {
                    HStack(spacing: 12) {
                        // Thumbnail (Main Color)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(nextItem.mainColor)
                            .frame(width: 44, height: 32)

                        VStack(alignment: .leading, spacing: 0) {
                            Text("UP NEXT")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            Text(nextItem.title)
                                .font(.system(size: 14, weight: .semibold))
                                .lineLimit(1)
                                .foregroundColor(.primary)
                        }
                        
                        Image(systemName: "chevron.forward")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(.regularMaterial)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
            }
            .padding(.horizontal, 16)
            
            // Bottom Layer: Back & Actions
            HStack(spacing: 12) {
                // Left: Back Button (Isolated)
                Button(action: {
                    // Back action
                }) {
                    Image(systemName: "chevron.backward")
                        .frame(width: 44, height: 44)
                }
                .padding(8)
                .background(.regularMaterial)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Spacer()
                
                // Right: Actions Pill (Comments, Perspectives)
                HStack(spacing: 20) {
                    Button(action: {
                        // Comments action
                    }) {
                        Image(systemName: "bubble.left")
                            .frame(width: 44, height: 44)
                    }
                    
                    Button(action: {
                        // Perspectives action
                    }) {
                        Image(systemName: "square.stack.3d.up")
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.regularMaterial)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 16)
        }
        .font(.system(size: 20))
        .foregroundColor(.primary)
    }
}
