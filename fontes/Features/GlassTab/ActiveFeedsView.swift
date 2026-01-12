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



#Preview {
    ActiveFeedsView()
}
