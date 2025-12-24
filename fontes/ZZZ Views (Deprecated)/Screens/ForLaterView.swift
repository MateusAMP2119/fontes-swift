//
//  ForLaterView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct ForLaterView: View {
    // Sample Data for Saved Stories
    let savedStories: [NewsArticle] = [
        NewsArticle(
            source: "The Atlantic",
            headline: "The Case for Slowing Down",
            timeAgo: "Saved 2d ago",
            author: "Arthur C. Brooks",
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?q=80&w=2670&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/The_Atlantic_logo.svg/2560px-The_Atlantic_logo.svg.png",
            isTopStory: false,
            tag: "Lifestyle"
        ),
        NewsArticle(
            source: "National Geographic",
            headline: "Hidden Worlds of the Ocean Deep",
            timeAgo: "Saved 5d ago",
            author: "Sylvia Earle",
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1682687220742-aba13b6e50ba?q=80&w=2670&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/6/6a/National_Geographic_Logo.svg",
            isTopStory: false,
            tag: "Science"
        ),
        NewsArticle(
            source: "Harvard Business Review",
            headline: "How to Lead in a Crisis",
            timeAgo: "Saved 1w ago",
            author: "Amy Edmondson",
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1556761175-5973dc0f32e7?q=80&w=2664&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/HBR_logo.svg/2560px-HBR_logo.svg.png",
            isTopStory: false,
            tag: "Leadership"
        ),
        NewsArticle(
            source: "Wired",
            headline: "The Future of AI is Agentic",
            timeAgo: "Saved 2w ago",
            author: "Kevin Kelly",
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1677442136019-21780ecad995?q=80&w=2664&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/9/95/Wired_logo.svg",
            isTopStory: false,
            tag: "Technology"
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // --- HEADER START ---
                    ForLaterHeaderView()
                    // --- HEADER END ---
                    
                    // Saved Stories Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Reading List")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            
                            Text("\(savedStories.count) articles")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Stories
                        ForEach(savedStories) { article in
                            PerspectiveNewsCard(article: article)
                                .padding(.horizontal)
                        }
                        
                        // Spacer for bottom tab bar
                        Color.clear.frame(height: 100)
                    }
                }
            }
            .scrollEdgeEffectStyle(.soft, for: .all)
            .background(Color(uiColor: .systemGroupedBackground))
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct ForLaterHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Row 1: Icon and Title
            HStack(alignment: .center, spacing: 6) {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.pink)
                    .offset(y: -1)
                
                Text("For Later")
                    .font(.system(size: 34, weight: .heavy))
                    .kerning(-1.4)
            }
            .foregroundStyle(.primary)
            
            // Row 2: Subtitle
            Text("Saved Stories")
                .font(.system(size: 34, weight: .heavy, design: .default))
                .foregroundStyle(Color.gray)
                .kerning(-1.4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}

#Preview {
    ForLaterView()
}
