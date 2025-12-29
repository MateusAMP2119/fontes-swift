//
//  DiscoverResultRow.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct DiscoverResultRow: View {
    let imageName: String
    let title: String
    let subtitle: String
    let details: String
    let isFollowing: Bool
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Image Placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(details)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
