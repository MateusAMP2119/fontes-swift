//
//  FeedRow.swift
//  fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import SwiftUI

struct FeedRow: View {
    let feed: Feed
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: feed.iconName)
                .font(.title3)
                .foregroundStyle(feed.color)
                .frame(width: 32, height: 32)
                .background(feed.color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            VStack(alignment: .leading) {
                Text(feed.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                if let description = feed.description {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}
