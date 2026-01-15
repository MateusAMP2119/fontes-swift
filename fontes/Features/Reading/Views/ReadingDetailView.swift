//
//  ReadingDetailView.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import SwiftUI
import Foundation

struct ReadingDetailView: View {
    let item: ReadingItem
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Main Scroll Content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header Image
                    headerImage
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Title & Metadata
                        VStack(alignment: .leading, spacing: 12) {
                            Text(item.title)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.primary)
                            
                            if let subtitle = item.subtitle {
                                Text(subtitle)
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            
                            metadataView
                        }
                        
                        // Tags
                        if !item.tags.isEmpty {
                            tagsView
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        // Article Content
                        if !item.content.isEmpty {
                            Text(item.content)
                                .font(.body)
                                .lineSpacing(6)
                                .foregroundColor(.primary)
                        } else {
                            // Fallback if no content is available yet
                            Text("No content available for this article.")
                                .font(.body)
                                .italic()
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .edgesIgnoringSafeArea(.top)
            
            // MARK: - Floating Close Button
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
        .highPriorityGesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 100 && abs(value.translation.width) < 50 {
                        dismiss()
                    }
                }
        )
        .onAppear {
            // Update last read item when viewing an article
            FeedStore.shared.updateLastRead(item: item)
        }
    }
    
    // MARK: - Subviews
    private var headerImage: some View {
        ZStack {
            if let imageURLString = item.imageURL, let url = URL(string: imageURLString) {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Rectangle()
                        .fill(item.mainColor.opacity(0.3))
                        .frame(height: 300)
                        .overlay {
                            ProgressView()
                        }
                }
            } else {
                Rectangle()
                    .fill(item.mainColor.opacity(0.3))
                    .frame(height: 300)
                    .overlay(
                        Image(systemName: "newspaper")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                    )
            }
        }
    }
    
    private var metadataView: some View {
        HStack(spacing: 8) {
            if !item.author.isEmpty {
                Text(item.author)
                    .fontWeight(.medium)
            }
            
            Text("·")
                .foregroundColor(.secondary)
            
            Text(item.time.isEmpty ? "Date" : item.time)
                .foregroundColor(.secondary)
        }
        .font(.subheadline)
    }
    
    private var tagsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(item.tags, id: \.self) { tag in
                    Text(tag.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(6)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

// MARK: - Previews

struct ReadingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockItem = ReadingItem(
            id: 1,
            title: "Hawaii wildfires: The latest news",
            source: "BBC News",
            time: "2h ago",
            author: "Max Matza",
            tags: ["US & Canada", "Wildfires"],
            sourceLogo: "https://example.com/logo.png",
            mainColor: Color.red
        )
        
        return ReadingDetailView(item: mockItem)
    }
}
