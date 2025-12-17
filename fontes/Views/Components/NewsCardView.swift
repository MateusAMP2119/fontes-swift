import SwiftUI

struct NewsCardView: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Area
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(article.isTopStory ? 1.6 : 1.3, contentMode: .fit)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                )
                .clipped()
            
            // Content Area
            VStack(alignment: .leading, spacing: article.isTopStory ? 12 : 8) {
                // Source
                HStack(spacing: 8) {
                    if article.isTopStory {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.red)
                                .frame(width: 20, height: 20)
                            Text(String(article.source.prefix(1)))
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    } else {
                        Image(systemName: "newspaper.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    
                    Text(article.source)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .textCase(.uppercase)
                        .lineLimit(1)
                }
                
                // Headline
                Text(article.headline)
                    .font(article.isTopStory ? .title3 : .subheadline)
                    .fontWeight(.bold)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Tag / Pill
                if let tag = article.tag, article.isTopStory {
                    Text(tag)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(Capsule())
                }
                
                Spacer(minLength: 0)
                
                // Footer
                HStack {
                    Text(article.timeAgo)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.gray)
                            .font(.system(size: article.isTopStory ? 20 : 16))
                    }
                }
            }
            .padding(12)
        }
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HStack(alignment: .top) {
        NewsCardView(article: NewsArticle(
            source: "POLITICO",
            headline: "Hegseth says he won't release full boat-strike video",
            timeAgo: "19m ago",
            author: nil,
            imageName: "placeholder",
            isTopStory: true,
            tag: "More politics coverage"
        ))
        .frame(width: 300)
        
        NewsCardView(article: NewsArticle(
            source: "LA Times",
            headline: "The last U.S. pennies sell for $16.7 million",
            timeAgo: "1h ago",
            author: nil,
            imageName: "placeholder",
            isTopStory: false,
            tag: nil
        ))
        .frame(width: 150)
    }
    .padding()
    .background(Color(uiColor: .secondarySystemBackground))
}
