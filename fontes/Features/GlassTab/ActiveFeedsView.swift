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
                Section("Fontes ativas") {
                    ForEach(feedStore.userFeeds) { feed in
                        FeedRow(feed: feed, isOn: Binding(
                            get: { feedStore.activeFeedIDs.contains(feed.id) },
                            set: { isActive in
                                feedStore.toggleFeed(feed)
                            }
                        ))
                    }
                }
                .padding(.top, 24)
                
                Section {
                    Button(action: {
                        showingCreateFeed = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Create New Feed")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.white)
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

#Preview {
    ActiveFeedsView()
}
