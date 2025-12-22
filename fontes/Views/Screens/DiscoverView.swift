//
//  DiscoverView.swift
//  fontes
//
//  Created by Mateus Costa on 18/12/2025.
//

import SwiftUI

struct DiscoverView: View {
    // Mock Data
    let trendingTopics = [
        "Artificial Intelligence",
        "Climate Change",
        "Space Exploration",
        "Electric Vehicles",
        "Mental Health",
        "Quantum Computing"
    ]
    
    let trendingSources = [
        (name: "The Verge", icon: "https://upload.wikimedia.org/wikipedia/commons/a/a2/The_Verge_logo.svg"),
        (name: "TechCrunch", icon: "https://upload.wikimedia.org/wikipedia/commons/b/b9/TechCrunch_logo.svg"),
        (name: "Wired", icon: "https://upload.wikimedia.org/wikipedia/commons/9/95/Wired_logo.svg"),
        (name: "Bloomberg", icon: "https://upload.wikimedia.org/wikipedia/commons/5/55/Bloomberg_L.P._logo.svg"),
        (name: "Reuters", icon: "https://upload.wikimedia.org/wikipedia/commons/8/8d/Reuters_Logo.svg")
    ]
    
    let trendingArticles: [NewsArticle] = [
        NewsArticle(
            source: "The Verge",
            headline: "Apple announces new AI features for iOS 19",
            timeAgo: "30m ago",
            author: "Nilay Patel",
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1611162617474-5b21e879e113?q=80&w=2574&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/a/a2/The_Verge_logo.svg",
            isTopStory: true,
            tag: "Technology"
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
            tag: "Startups"
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
        ),
        NewsArticle(
            source: "Bloomberg",
            headline: "Global markets rally as inflation data shows cooling",
            timeAgo: "5h ago",
            author: "John Doe",
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1611974765270-ca1258634369?q=80&w=2664&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/5/55/Bloomberg_L.P._logo.svg",
            isTopStory: false,
            tag: "Finance"
        ),
        NewsArticle(
            source: "Reuters",
            headline: "Scientists discover new species in the Amazon rainforest",
            timeAgo: "6h ago",
            author: "Jane Smith",
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1516934024742-b461fba47600?q=80&w=2574&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/8/8d/Reuters_Logo.svg",
            isTopStory: false,
            tag: "Science"
        )
    ]
    
    var body: some View {
        @State var search: String = ""

        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    DiscoverHeaderView()
                    
                    // Trending Topics
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: "Trending Topics")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(Array(trendingTopics.enumerated()), id: \.offset) { index, topic in
                                    TopicRankingCard(rank: index + 1, topic: topic)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Trending Sources
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: "Top Sources")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(Array(trendingSources.enumerated()), id: \.offset) { index, source in
                                    SourceRankingCard(rank: index + 1, name: source.name, logoURL: source.icon)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Trending Articles
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: "Viral Stories")
                        VStack(spacing: 16) {
                            ForEach(Array(trendingArticles.enumerated()), id: \.offset) { index, article in
                                ArticleRankingRow(rank: index + 1, article: article)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.vertical)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .searchable(
                text: $search,
                placement: .toolbar,
                prompt: "Type here to search"
            )
        }
    }
}

struct DiscoverHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "sparkle.magnifyingglass")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.purple)
                
                Text("Discover")
                    .font(.system(size: 34, weight: .heavy))
                    .kerning(-1.4)
            }
            .foregroundStyle(.primary)
            
            Text("Explore what's happening now")
                .font(.system(size: 20, weight: .medium, design: .default))
                .foregroundStyle(Color.gray)
                .kerning(-0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.horizontal)
    }
}

struct TopicRankingCard: View {
    let rank: Int
    let topic: String
    
    // Generate a random color based on the topic string hash for variety
    var randomColor: Color {
        let colors: [Color] = [.blue, .purple, .pink, .orange, .green, .teal]
        let index = abs(topic.hashValue) % colors.count
        return colors[index]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("#\(rank)")
                .font(.system(size: 40, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))
            
            Spacer()
            
            Text(topic)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .lineLimit(2)
        }
        .padding(16)
        .frame(width: 160, height: 160)
        .background(
            LinearGradient(
                colors: [randomColor, randomColor.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: randomColor.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct SourceRankingCard: View {
    let rank: Int
    let name: String
    let logoURL: String
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topLeading) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 80, height: 80)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                if let url = URL(string: logoURL) {
                    if logoURL.lowercased().hasSuffix(".svg") {
                        SVGImageView(url: url)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .offset(x: 15, y: 15)
                    } else {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .offset(x: 15, y: 15)
                    }
                }
                
                Text("\(rank)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.black)
                    .frame(width: 32, height: 32)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .offset(x: -5, y: -5)
            }
            
            Text(name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .frame(width: 100)
    }
}

struct ArticleRankingRow: View {
    let rank: Int
    let article: NewsArticle
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(rank)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(width: 30)
            
            if let imageURL = article.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.2))
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.headline)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundStyle(.primary)
                
                HStack {
                    if let sourceLogo = article.sourceLogo, let url = URL(string: sourceLogo) {
                        if sourceLogo.lowercased().hasSuffix(".svg") {
                            SVGImageView(url: url)
                                .frame(width: 12, height: 12)
                        } else {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Color.clear
                            }
                            .frame(width: 12, height: 12)
                        }
                    }
                    
                    Text(article.source)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if let author = article.author {
                        Text("•")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(author)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("•")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(article.timeAgo)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    DiscoverView()
}
