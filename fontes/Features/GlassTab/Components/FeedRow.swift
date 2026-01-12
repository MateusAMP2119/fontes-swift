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
    
    var newCount: Int {
        // Calculate items for this feed published today
        let today = Calendar.current.startOfDay(for: Date())
        return FeedStore.shared.items.filter { item in
            feed.matches(item) && (item.publishedDate ?? Date.distantPast) >= today
        }.count
    }
    
    var body: some View {
        HStack(spacing: 16) {
            FeedIconCollage(feed: feed, size: 60)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(feed.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                if let description = feed.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                HStack(spacing: 8) {
                    // Sources Chip
                    Text("\(feed.sources.count) fontes")
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    // News Chip
                    Text("\(newCount) novas")
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}
