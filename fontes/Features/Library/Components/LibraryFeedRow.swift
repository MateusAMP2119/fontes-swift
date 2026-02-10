//
//  LibraryFeedRow.swift
//  Fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

struct LibraryFeedRow: View {
    let feed: Feed
    let onTap: () -> Void
    
    var newCount: Int {
        // Calculate items for this feed published today
        let today = Calendar.current.startOfDay(for: Date())
        return FeedStore.shared.items.filter { item in
            feed.matches(item) && (item.publishedDate ?? Date.distantPast) >= today
        }.count
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                FeedIconCollage(feed: feed, size: 60)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(feed.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    if let description = feed.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: 8) {
                        // Sources Chip
                        Text("\(feed.sources.count) Fontes")
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
                
                // Keep Pinned indicator but with updated style/position if needed,
                // or just rely on the list order. Let's keep it subtle.
                if feed.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color(.tertiaryLabel))
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Grid Variant REMOVED (No longer used)
// Kept commented out just in case or we can just delete it.
// Deleted as per plan to move to list-only.

#Preview("Row") {
    VStack(spacing: 0) {
        LibraryFeedRow(feed: Feed.defaultFeed) {}
            .padding()
    }
}
