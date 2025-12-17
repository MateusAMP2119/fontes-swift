import SwiftUI

struct NewsCardView: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Area
            Group {
                if let imageURL = article.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundStyle(.gray)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.gray)
                        )
                }
            }
            .aspectRatio(1.6, contentMode: .fit)
            .clipped()
            
            // Content Area
            VStack(alignment: .leading, spacing: 8) {
                // Source
                if let sourceLogo = article.sourceLogo, let url = URL(string: sourceLogo) {
                    if sourceLogo.lowercased().hasSuffix(".svg") {
                        SVGImageView(url: url)
                            .frame(height: 24)
                            .frame(alignment: .leading)
                    } else {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                            case .empty, .failure:
                                sourceView
                            @unknown default:
                                sourceView
                            }
                        }
                    }
                } else {
                    sourceView
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
        .padding(.horizontal, 2)
    }
    
    @ViewBuilder
    var sourceView: some View {
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
    }
}
