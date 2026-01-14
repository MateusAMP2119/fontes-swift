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
    var nextItem: ReadingItem? = nil
    var onNext: ((ReadingItem) -> Void)? = nil
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Main Scroll Content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header Image
                    headerImage
                        .frame(height: 300)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title & Metadata
                        Text(item.title)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                        
                        metadataView
                        
                        // Tags
                        if !item.tags.isEmpty {
                            tagsView
                        }
                        
                        // Placeholder Content
                        contentPlaceholder
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
            .edgesIgnoringSafeArea(.top)
            
            // MARK: - Floating Close Button
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .glassEffect()
                }
                Spacer()
            }
            .padding(.horizontal)
            
            // MARK: - Bottom Actions
            VStack {
                Spacer()
                ReadingActions(currentItem: item, nextItem: item, showHint: false)
            }
        }
        .navigationBarHidden(true)
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
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(item.mainColor.opacity(0.3))
                        .overlay {
                            ProgressView()
                        }
                }
            } else {
                Rectangle()
                    .fill(item.mainColor.opacity(0.3))
            }
        }
    }
    
    private var metadataView: some View {
        HStack(spacing: 4) {
            Text(item.author.isEmpty ? "Author Name" : item.author)
                .fontWeight(.medium)
            Text("·")
            Text(item.time.isEmpty ? "Date" : item.time)
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    
    private var tagsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(item.tags, id: \.self) { tag in
                    Text(tag.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.15))
                        .cornerRadius(4)
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    private var contentPlaceholder: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("With schools closed, Lahaina parents left children at home while they worked; confirmed death toll of 110 is expected to rise")
                .font(.system(size: 18))
                .foregroundColor(.secondary)
                .lineSpacing(4)
            
            Text("This is an immersive reading view for the article titled \"\(item.title)\". In a real application, the full content of the article would be fetched and displayed here.")
                .font(.system(size: 18))
                .lineSpacing(6)
            
            ForEach(0..<5) { _ in
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")
                    .font(.system(size: 18))
                    .lineSpacing(6)
            }
        }
    }
    

    
    private func triggerNextArticle(_ next: ReadingItem) {
        withAnimation {
            onNext?(next)
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
        
        let nextItem = ReadingItem(
            id: 2,
            title: "Another interesting article for you to read",
            source: "Theverge",
            time: "4h ago",
            author: "Nilay Patel",
            tags: ["Tech", "Analysis"],
            sourceLogo: "https://example.com/logo2.png",
            mainColor: Color.blue
        )
        
        return ReadingDetailView(
            item: mockItem,
            nextItem: nextItem,
            onNext: { newItem in
                print("Transit to: \(newItem.title)")
            }
        )
    }
}
