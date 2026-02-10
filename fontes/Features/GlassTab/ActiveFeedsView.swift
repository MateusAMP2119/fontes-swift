//
//  ActiveFeedsView.swift
//  Fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

struct ActiveFeedsView: View {
    @ObservedObject var feedStore = FeedStore.shared
    @State private var showingCreateFeed = false
    @State private var searchText = ""
    
    @Environment(\.dismiss) var dismiss

    var filteredFeeds: [Feed] {
        if searchText.isEmpty {
            return feedStore.userFeeds
        } else {
            return feedStore.userFeeds.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            HStack {
                Text("Fontes ativas")
                    .font(.title).bold()
                
                Spacer()
                
                Button(action: {
                    showingCreateFeed = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Criar")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                }
                .glassEffect(.regular.tint(.red).interactive())
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.gray)
                        .frame(width: 32, height: 32)
                }
                .glassEffect(.regular.interactive())
                .clipShape(Circle())
            }
            .padding(.horizontal, 26)
            .padding(.top, 24)
            .padding(.bottom, 16)
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Pesquisar pelas tuas Fontes", text: $searchText)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            // List
            List {
                ForEach(filteredFeeds) { feed in
                    FeedRow(feed: feed, isOn: Binding(
                        get: { feedStore.activeFeedIDs.contains(feed.id) },
                        set: { _ in feedStore.toggleFeed(feed) }
                    ))
                    .listRowInsets(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }

        .background(Color.white)
        .sheet(isPresented: $showingCreateFeed) {
            CreateFeedView { newFeed in
                feedStore.addUserFeed(newFeed)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
}



#Preview {
    ActiveFeedsView()
}
