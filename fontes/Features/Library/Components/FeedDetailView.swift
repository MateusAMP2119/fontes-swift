//
//  FeedDetailView.swift
//  fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

struct FeedDetailView: View {
    let feed: Feed
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(feed.color.gradient)
                                .frame(width: 140, height: 140)
                            
                            Image(systemName: feed.iconName)
                                .font(.system(size: 60))
                                .foregroundStyle(.white)
                        }
                        .shadow(color: feed.color.opacity(0.4), radius: 20, y: 10)
                        
                        Text(feed.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let description = feed.description {
                            Text(description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Stats
                    HStack(spacing: 32) {
                        statItem(value: feed.sources.count, label: "Sources")
                        statItem(value: feed.journalists.count, label: "Journalists")
                        statItem(value: feed.tags.count, label: "Tags")
                        statItem(value: feed.keywords.count, label: "Keywords")
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Content sections
                    VStack(alignment: .leading, spacing: 20) {
                        if !feed.sources.isEmpty {
                            feedSection(title: "Sources", items: feed.sources, icon: "building.2")
                        }
                        
                        if !feed.journalists.isEmpty {
                            feedSection(title: "Journalists", items: feed.journalists, icon: "person")
                        }
                        
                        if !feed.tags.isEmpty {
                            feedSection(title: "Tags", items: feed.tags, icon: "tag")
                        }
                        
                        if !feed.keywords.isEmpty {
                            feedSection(title: "Keywords", items: feed.keywords, icon: "text.magnifyingglass")
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func statItem(value: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private func feedSection(title: String, items: [String], icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                Text(title.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fontWeight(.semibold)
            }
            
            FlowLayout(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color(.systemGray6))
                        )
                }
            }
        }
    }
}

#Preview {
    FeedDetailView(feed: Feed.defaultFeed)
}
