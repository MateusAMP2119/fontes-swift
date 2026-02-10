//
//  FilterChip.swift
//  Fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import SwiftUI

struct FilterChip: View {
    let text: String
    let isSelected: Bool
    var imageUrl: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
                if let imageUrl, let url = URL(string: imageUrl) {
                    // Logo Style
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Color.secondary.opacity(0.1)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Color.secondary.opacity(0.1) // Fallback
                        @unknown default:
                            Color.secondary.opacity(0.1)
                        }
                    }
                    .frame(height: 24) // Fixed height for logos
                    .frame(minWidth: 60) // Ensure reasonable width
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                } else {
                    // Text Style
                    Text(text)
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
            }
            .background(Color.clear)
            .foregroundColor(.primary)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.red : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}
