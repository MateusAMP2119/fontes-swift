//
//  ForYouView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct ForYouView: View {
    @Binding var algorithms: [Algorithm]
    @Binding var selectedAlgorithmId: UUID?
    
    // Mock Data
    let forYouStories: [NewsArticle] = [
        NewsArticle(
            source: "The Verge",
            headline: "Apple announces new AI features for iOS 19",
            timeAgo: "30m ago",
            author: "Nilay Patel",
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1611162617474-5b21e879e113?q=80&w=2574&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/a/a2/The_Verge_logo.svg",
            isTopStory: true,
            tag: "Technology",
            perspectives: [
                Perspective(sourceName: "TechCrunch", sourceLogoName: "tc", perspectiveType: .analysis, headline: "Why this matters for developers"),
                Perspective(sourceName: "Bloomberg", sourceLogoName: "bb", perspectiveType: .global, headline: "Market reaction to Apple's AI push"),
                Perspective(sourceName: "Apple Newsroom", sourceLogoName: "apple", perspectiveType: .official, headline: "Introducing Apple Intelligence")
            ]
        ),
        NewsArticle(
            source: "TechCrunch",
            headline: "This new startup wants to replace your phone with a pin",
            timeAgo: "2h ago",
            author: "Sarah Perez",
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1519389950473-47ba0277781c?q=80&w=2670&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/b/b9/TechCrunch_logo.svg",
            isTopStory: false,
            tag: "Startups",
            perspectives: [
                Perspective(sourceName: "The Verge", sourceLogoName: "verge", perspectiveType: .analysis, headline: "Is the AI Pin ready for prime time?"),
                Perspective(sourceName: "Humane", sourceLogoName: "humane", perspectiveType: .official, headline: "A new way to interact with technology")
            ]
        ),
        NewsArticle(
            source: "Wired",
            headline: "The future of electric cars is not what you think",
            timeAgo: "4h ago",
            author: nil,
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1593941707882-a5bba14938c7?q=80&w=2672&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/9/95/Wired_logo.svg",
            isTopStory: false,
            tag: "Transportation"
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        ForYouHeaderView()
                        
                        // Content
                        LazyVStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Curated for you")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ForEach(forYouStories) { article in
                                PerspectiveNewsCard(article: article)
                                    .padding(.horizontal)
                            }
                            
                            // Spacer for the bottom dock
                            Color.clear.frame(height: 100)
                        }
                    }
                }
                .scrollEdgeEffectStyle(.soft, for: .all)
                .background(Color(uiColor: .systemGroupedBackground))
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}



struct ForYouHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "sparkles")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.blue)
                    .offset(y: -1)
                
                Text("For You")
                    .font(.system(size: 34, weight: .heavy))
                    .kerning(-1.4)
            }
            .foregroundStyle(.primary)
            
            Text("Your personal feed")
                .font(.system(size: 20, weight: .medium, design: .default))
                .foregroundStyle(Color.gray)
                .kerning(-0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}


#Preview {
    ForYouView(algorithms: .constant([
        Algorithm(name: "Tech Trends", icon: "desktopcomputer", isSelected: true)
    ]), selectedAlgorithmId: .constant(nil))
}
