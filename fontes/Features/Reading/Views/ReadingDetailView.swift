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
    
    // MARK: - State
    @State private var showNextArticleHint = false
    @State private var dragOffset: CGFloat = 0
    @State private var isScrolledToBottom = false
    
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
                        
                        // Bottom Detector
                        GeometryReader { proxy -> Color in
                            let minY = proxy.frame(in: .global).minY
                            let screenHeight = UIScreen.main.bounds.height
                            let threshold = screenHeight - 100 // Trigger when close to bottom
                            
                            DispatchQueue.main.async {
                                if minY < threshold {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        isScrolledToBottom = true
                                        showNextArticleHint = true
                                    }
                                } else {
                                    withAnimation {
                                        isScrolledToBottom = false
                                        // Optional: Hide hint if scrolled back up considerably?
                                        // For now sticky once shown or strictly bound to bottom
                                    }
                                }
                            }
                            return Color.clear
                        }
                        .frame(height: 50)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120) // Space for next article card
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
            
            // MARK: - Next Article Pull-Up Card
            if let nextItem = nextItem {
                VStack {
                    Spacer()
                    nextArticleCard(nextItem)
                        .offset(y: showNextArticleHint ? 0 : 200) // 200 to hide
                        .offset(y: dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Allow dragging up (negative translation)
                                    if value.translation.height < 0 {
                                        dragOffset = value.translation.height
                                    }
                                }
                                .onEnded { value in
                                    // If dragged up significantly, trigger transition
                                    if value.translation.height < -50 {
                                        triggerNextArticle(nextItem)
                                    } else {
                                        // Reset
                                        withAnimation {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                        .onTapGesture {
                            triggerNextArticle(nextItem)
                        }
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Subviews
    
    private var headerImage: some View {
        ZStack {
            if let url = URL(string: "https://picsum.photos/800/600") {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFill()
                    } else {
                        Color.gray.opacity(0.3)
                    }
                }
            } else {
                Color.gray.opacity(0.3)
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
    
    private func nextArticleCard(_ next: ReadingItem) -> some View {
        VStack(spacing: 0) {
            // Drag Indicator
            if showNextArticleHint {
                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
            }
            
            HStack(spacing: 16) {
                // Next Label & Title
                VStack(alignment: .leading, spacing: 4) {
                    Text("UP NEXT")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    Text(next.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Color/Image Preview
                ZStack {
                    next.mainColor
                }
                .frame(width: 50, height: 50)
                .cornerRadius(8)
            }
            .padding(20)
            .padding(.bottom, 20)
        }
        .background(.regularMaterial)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
    }
    
    private func triggerNextArticle(_ next: ReadingItem) {
        withAnimation {
            onNext?(next)
            // Reset state for new article
            showNextArticleHint = false
            isScrolledToBottom = false
        }
    }
}

// Extension to support specific corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
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
