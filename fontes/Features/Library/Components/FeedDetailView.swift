//
//  FeedDetailView.swift
//  fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

struct FeedDetailView: View {
    @Binding var feed: Feed
    @Environment(\.dismiss) private var dismiss
    @StateObject private var feedStore = FeedStore.shared
    @State private var selectedItem: ReadingItem?
    @FocusState private var isNameFocused: Bool
    
    // Compute items for this feed
    var items: [ReadingItem] {
        // Filter items that match the current feed
        let list = feedStore.items.filter { item in
            feed.matches(item)
        }
        
        return list
    }


    
    // Split items into two columns for masonry layout
    var leftColumnItems: [ReadingItem] {
        items.enumerated().filter { offset, element in offset % 2 == 0 }.map { $0.element }
    }
    
    var rightColumnItems: [ReadingItem] {
        items.enumerated().filter { offset, element in offset % 2 != 0 }.map { $0.element }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Compact Header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .center, spacing: 16) {
                            FeedIconCollage(feed: feed, size: 80)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 8) {
                                    TextField("Feed Name", text: $feed.name)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .textFieldStyle(.plain)
                                        .focused($isNameFocused)
                                    
                                    Button {
                                        isNameFocused = true
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                if let description = feed.description {
                                    Text(description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Info Chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                if !feed.sources.isEmpty {
                                    InfoChip(icon: "building.2", text: "\(feed.sources.count) Sources")
                                }
                                if !feed.journalists.isEmpty {
                                    InfoChip(icon: "person.2", text: "\(feed.journalists.count) Journalists")
                                }
                                if !feed.tags.isEmpty {
                                    InfoChip(icon: "tag", text: "\(feed.tags.count) Tags")
                                }
                                if !feed.keywords.isEmpty {
                                    InfoChip(icon: "text.magnifyingglass", text: "\(feed.keywords.count) Keywords")
                                }
                                
                                Divider()
                                    .frame(height: 20)
                                
                                Button {
                                    // TODO: Show preferences
                                } label: {
                                    Image(systemName: "slider.horizontal.3")
                                        .font(.caption)
                                        .foregroundStyle(.primary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(Color(.systemGray6))
                                        )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 36)

                    
                    if items.isEmpty {
                        // Empty state
                        VStack(spacing: 16) {
                            Image(systemName: "newspaper")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)
                            Text("No articles found")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                    } else {
                        // Article Grid (Masonry)
                        HStack(alignment: .top, spacing: 16) {
                            // Left Column
                            LazyVStack(spacing: 16) {
                                ForEach(leftColumnItems) { item in
                                    Button {
                                        selectedItem = item
                                    } label: {
                                        GridCard(item: item)
                                            .transition(.scale.combined(with: .opacity))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                            // Right Column
                            LazyVStack(spacing: 16) {
                                ForEach(rightColumnItems) { item in
                                    Button {
                                        selectedItem = item
                                    } label: {
                                        GridCard(item: item)
                                            .transition(.scale.combined(with: .opacity))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                }
                .padding(.bottom, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .presentationDragIndicator(.visible)

            .fullScreenCover(item: $selectedItem) { item in
                // Determine next item for swipe navigation
                let nextItem: ReadingItem? = {
                    if let index = items.firstIndex(where: { (r: ReadingItem) in r.id == item.id }),
                       index + 1 < items.count {
                        return items[index + 1]
                    }
                    return nil
                }()
                
                ReadingDetailView(
                    item: item,
                    nextItem: nextItem,
                    onNext: { next in
                        selectedItem = next
                    }
                )
            }
        }
    }


#Preview {
    FeedDetailView(feed: .constant(Feed.defaultFeed))
}

struct InfoChip: View {
    let icon: String
    let text: String
    var color: Color = .secondary
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color(.systemGray6))
        )
    }
}
