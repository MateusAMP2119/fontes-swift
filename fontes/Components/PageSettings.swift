//
//  AppHeaderTrailing.swift
//  fontes
//
//  Created by Mateus Costa on 10/01/2026.
//

import SwiftUI

struct PageSettings: View {
    @ObservedObject var feedStore = FeedStore.shared
    var onFiltersTap: () -> Void = {}
    
    var activeFeedText: String {
        if feedStore.activeFeedIDs.isEmpty {
            if let defaultFeed = feedStore.userFeeds.first(where: { $0.isDefault }) {
                return defaultFeed.name
            }
            return "Feed"
        } else if feedStore.activeFeedIDs.count == 1 {
            if let id = feedStore.activeFeedIDs.first,
               let feed = feedStore.userFeeds.first(where: { $0.id == id }) {
                return feed.name
            }
            return "Feed"
        } else {
            return "\(feedStore.activeFeedIDs.count) Feeds"
        }
    }
    
    var activeFeedColor: Color? {
        if feedStore.activeFeedIDs.isEmpty {
            if let defaultFeed = feedStore.userFeeds.first(where: { $0.isDefault }) {
                return defaultFeed.color
            }
            return nil
        } else if feedStore.activeFeedIDs.count == 1 {
            if let id = feedStore.activeFeedIDs.first,
               let feed = feedStore.userFeeds.first(where: { $0.id == id }) {
                return feed.color
            }
            return nil
        } else {
            return nil
        }
    }
    
    var body: some View {
        Button(action: onFiltersTap) {
            HStack(spacing: 8) {
                if let color = activeFeedColor {
                    Circle()
                        .fill(color)
                        .frame(width: 8, height: 8)
                }
                
                Text(activeFeedText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)

                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .glassEffect(.regular.interactive())
        }
    }
}

#Preview {
    PageSettings()
}
