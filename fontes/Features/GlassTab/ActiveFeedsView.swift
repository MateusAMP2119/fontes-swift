//
//  ActiveFeedsView.swift
//  fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

struct ActiveFeedsView: View {
    @ObservedObject var feedStore = FeedStore.shared
    @State private var showingCreateFeed = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Select the feeds you want to see on your Home screen.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                }
                
                Section("My Feeds") {
                    ForEach(feedStore.userFeeds) { feed in
                        FeedRow(feed: feed, isSelected: feedStore.activeFeedIDs.contains(feed.id)) {
                            feedStore.toggleFeed(feed)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let feed = feedStore.userFeeds[index]
                            if !feed.isDefault {
                                feedStore.removeUserFeed(feed)
                            }
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        showingCreateFeed = true
                    }) {
                        Label("Create New Feed", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Your Feeds")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingCreateFeed) {
                CreateFeedView { newFeed in
                    feedStore.addUserFeed(newFeed)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

struct FeedRow: View {
    let feed: Feed
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Color.accentColor)
                } else {
                    Image(systemName: "circle")
                        .font(.title3)
                        .foregroundStyle(.secondary.opacity(0.5))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ActiveFeedsView()
}
