import SwiftUI

struct PerspectiveNewsCard: View {
    let article: NewsArticle
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main Image
            imageSection
            
            VStack(alignment: .leading, spacing: 12) {
                // Source & Time
                HStack {
                    if let sourceLogo = article.sourceLogo, let url = URL(string: sourceLogo) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            Circle().fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                    }
                    
                    Text(article.source)
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text("• \(article.timeAgo)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // Headline
                Text(article.headline)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(3)
                
                // Perspectives Section
                if let perspectives = article.perspectives, !perspectives.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: {
                            withAnimation(.spring()) {
                                isExpanded.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundStyle(.indigo)
                                Text(isExpanded ? "Show Less" : "\(perspectives.count) Perspectives Available")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(Color.indigo.opacity(0.1))
                            )
                        }
                        .buttonStyle(.plain)
                        
                        if isExpanded {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(perspectives) { perspective in
                                    PerspectiveRow(perspective: perspective)
                                }
                            }
                            .padding(.top, 12)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
    }
    
    private var imageSection: some View {
        GeometryReader { geometry in
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
                            .frame(width: geometry.size.width, height: 200)
                            .clipped()
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
                // Fallback to local image name if URL is missing
                Image(article.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 200)
                    .clipped()
            }
        }
        .frame(height: 200)
    }
}

struct PerspectiveRow: View {
    let perspective: Perspective
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon Column with Thread
            ZStack(alignment: .top) {
                // Thread Line
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
                
                // Source Logo
                Circle()
                    .fill(Color(uiColor: .secondarySystemBackground)) // Mask the thread behind the icon
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                Text(perspective.sourceName.prefix(1))
                                    .font(.caption2)
                                    .fontWeight(.bold)
                            )
                    )
            }
            .frame(width: 24)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(perspective.perspectiveType.rawValue.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                
                Text(perspective.headline)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    let samplePerspectives = [
        Perspective(sourceName: "Global News", sourceLogoName: "globe", perspectiveType: .global, headline: "International impact of the event discussed by world leaders"),
        Perspective(sourceName: "Tech Daily", sourceLogoName: "chip", perspectiveType: .analysis, headline: "Deep dive into the technical implications"),
        Perspective(sourceName: "Official Press", sourceLogoName: "building", perspectiveType: .official, headline: "Official statement released regarding the incident")
    ]
    
    let sampleArticle = NewsArticle(
        source: "The Daily Post",
        headline: "Major Event Shakes the Industry",
        timeAgo: "2h ago",
        author: "Jane Doe",
        imageName: "sample_news", // Assuming this exists or will fallback
        imageURL: "https://picsum.photos/600/400",
        sourceLogo: nil,
        isTopStory: true,
        tag: "Technology",
        perspectives: samplePerspectives
    )
    
    return PerspectiveNewsCard(article: sampleArticle)
        .padding()
}
