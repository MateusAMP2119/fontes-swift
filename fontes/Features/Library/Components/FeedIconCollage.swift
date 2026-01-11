//
//  FeedIconCollage.swift
//  fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

/// Displays a collage of source logos for a feed
/// Similar to Spotify's playlist cover art collage
struct FeedIconCollage: View {
    let feed: Feed
    let size: CGFloat
    
    private var sourceLogos: [(name: String, logoURL: String, color: Color)] {
        // Match feed sources with RSSFeed to get logos
        feed.sources.compactMap { sourceName in
            if let rssFeed = RSSFeed.defaultFeeds.first(where: { $0.name == sourceName }) {
                return (rssFeed.name, rssFeed.logoURL, rssFeed.defaultColor)
            }
            return nil
        }
    }
    
    var body: some View {
        Group {
            if sourceLogos.isEmpty {
                // Fallback to icon if no sources
                fallbackIcon
            } else if sourceLogos.count == 1 {
                // Single source - show full logo
                singleSourceView(sourceLogos[0])
            } else if sourceLogos.count == 2 {
                // Two sources - split vertically
                twoSourcesView
            } else if sourceLogos.count == 3 {
                // Three sources - one large + two small
                threeSourcesView
            } else {
                // Four or more - 2x2 grid
                fourSourcesView
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    // MARK: - Fallback Icon
    private var fallbackIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(feed.color.gradient)
            
            Image(systemName: feed.iconName)
                .font(.system(size: size * 0.4))
                .foregroundStyle(.white)
        }
    }
    
    // MARK: - Single Source
    private func singleSourceView(_ source: (name: String, logoURL: String, color: Color)) -> some View {
        ZStack {
            Rectangle()
                .fill(Color(.systemBackground))
            
            AsyncImage(url: URL(string: source.logoURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(size * 0.15)
                case .failure:
                    sourceInitials(source.name, color: source.color)
                case .empty:
                    ProgressView()
                @unknown default:
                    sourceInitials(source.name, color: source.color)
                }
            }
        }
    }
    
    // MARK: - Two Sources
    private var twoSourcesView: some View {
        HStack(spacing: 1) {
            ForEach(0..<2, id: \.self) { index in
                sourceCell(sourceLogos[index])
            }
        }
        .background(Color(.systemGray4))
    }
    
    // MARK: - Three Sources
    private var threeSourcesView: some View {
        HStack(spacing: 1) {
            sourceCell(sourceLogos[0])
            
            VStack(spacing: 1) {
                sourceCell(sourceLogos[1])
                sourceCell(sourceLogos[2])
            }
        }
        .background(Color(.systemGray4))
    }
    
    // MARK: - Four Sources (2x2 Grid)
    private var fourSourcesView: some View {
        VStack(spacing: 1) {
            HStack(spacing: 1) {
                sourceCell(sourceLogos[0])
                sourceCell(sourceLogos[1])
            }
            HStack(spacing: 1) {
                sourceCell(sourceLogos[2])
                if sourceLogos.count > 3 {
                    sourceCell(sourceLogos[3])
                } else {
                    moreIndicator
                }
            }
        }
        .background(Color(.systemGray4))
    }
    
    // MARK: - Source Cell
    private func sourceCell(_ source: (name: String, logoURL: String, color: Color)) -> some View {
        ZStack {
            Rectangle()
                .fill(Color(.systemBackground))
            
            AsyncImage(url: URL(string: source.logoURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(4)
                case .failure:
                    sourceInitials(source.name, color: source.color)
                case .empty:
                    ProgressView()
                        .scaleEffect(0.5)
                @unknown default:
                    sourceInitials(source.name, color: source.color)
                }
            }
        }
    }
    
    // MARK: - Source Initials Fallback
    private func sourceInitials(_ name: String, color: Color) -> some View {
        ZStack {
            Rectangle()
                .fill(color.gradient)
            
            Text(String(name.prefix(1)))
                .font(.system(size: size * 0.25, weight: .bold))
                .foregroundStyle(.white)
        }
    }
    
    // MARK: - More Indicator
    private var moreIndicator: some View {
        ZStack {
            Rectangle()
                .fill(Color(.systemGray5))
            
            Text("+\(sourceLogos.count - 3)")
                .font(.system(size: size * 0.2, weight: .semibold))
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            FeedIconCollage(feed: Feed.defaultFeed, size: 56)
            FeedIconCollage(feed: Feed.defaultFeed, size: 100)
        }
        
        // Test with different source counts
        FeedIconCollage(
            feed: Feed(name: "Single", sources: ["Público"]),
            size: 100
        )
        
        FeedIconCollage(
            feed: Feed(name: "Two", sources: ["Público", "Observador"]),
            size: 100
        )
        
        FeedIconCollage(
            feed: Feed(name: "Three", sources: ["Público", "Observador", "RTP Notícias"]),
            size: 100
        )
    }
    .padding()
}
