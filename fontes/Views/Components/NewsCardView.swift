import SwiftUI

struct NewsCardView: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if article.isTopStory {
                // Top Story Layout
                VStack(alignment: .leading, spacing: 12) {
                    // Image
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(1.5, contentMode: .fit)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.gray)
                        )
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Source
                        HStack {
                            Image(systemName: "newspaper.fill") // Placeholder for logo
                                .foregroundStyle(.red)
                            Text(article.source)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                        }
                        
                        // Headline
                        Text(article.headline)
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        
                        // Metadata
                        HStack {
                            Text(article.timeAgo)
                            if let author = article.author {
                                Text("• \(author)")
                            }
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(.gray)
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 12)
                }
            } else {
                // Standard Story Layout
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        // Source
                        HStack {
                            if let tag = article.tag {
                                Text(article.source)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.red)
                            } else {
                                Image(systemName: "newspaper") // Placeholder
                                    .font(.caption)
                                Text(article.source)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                            }
                        }
                        
                        // Headline
                        Text(article.headline)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        
                        if let tag = article.tag {
                            Text(tag)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        Spacer()
                        
                        // Metadata
                        HStack {
                            Text(article.timeAgo)
                            if let author = article.author {
                                Text("• \(author)")
                            }
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(.gray)
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    // Image
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundStyle(.gray)
                        )
                        .cornerRadius(8)
                }
                .frame(height: 120)
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    VStack {
        NewsCardView(article: NewsArticle(
            source: "NBC NEWS",
            headline: "Already-shaky job market weakened in October and November, delayed federal data shows",
            timeAgo: "18m ago",
            author: "Steve Kopack",
            imageName: "placeholder",
            isTopStory: true,
            tag: nil
        ))
        
        NewsCardView(article: NewsArticle(
            source: "POLITICO",
            headline: "White House weighs risks of a health-care fight as ACA subsidies set to expire",
            timeAgo: "19m ago",
            author: nil,
            imageName: "placeholder",
            isTopStory: false,
            tag: "More politics coverage"
        ))
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
