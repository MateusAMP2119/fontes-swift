//
//  LibraryFeedRow.swift
//  fontes
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
                // Feed Icon Collage
                FeedIconCollage(feed: feed, size: 56)
                
                // Feed Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(feed.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    if let description = feed.description {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: 8) {
                        // Sources Chip
                        Text("\(feed.sources.count) fontes")
                            .font(.caption2.weight(.medium))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        // News Chip
                        Text("\(newCount) novas")
                            .font(.caption2.weight(.medium))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
                }
                .padding(.vertical, 2)
                
                Spacer()
                
                // Pinned indicator
                if feed.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Grid Variant for compact view
struct LibraryFeedGridItem: View {
    let feed: Feed
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Feed Icon Collage
                FeedIconCollage(feed: feed, size: 100)
                
                // Feed Name
                Text(feed.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Row") {
    VStack(spacing: 0) {
        LibraryFeedRow(feed: Feed.defaultFeed) {}
    }
}

#Preview("Grid") {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
        LibraryFeedGridItem(feed: Feed.defaultFeed) {}
    }
    .padding()
}
