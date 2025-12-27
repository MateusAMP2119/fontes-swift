//
//  DiscoverArticleDetailView.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import SwiftUI

struct DiscoverArticleDetailView: View {
    let article: DiscoverArticle
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image Area
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(article.color)
                        .frame(height: 300)
                        
                    // Gradient overlay
                    LinearGradient(
                        colors: [.black.opacity(0.6), .clear],
                        startPoint: .bottom,
                        endPoint: .center
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(article.subtitle.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(article.title)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(3)
                        
                        Text(article.details)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(20)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        if article.isFollowing {
                            Label("Following", systemImage: "checkmark")
                                .font(.subheadline)
                                .foregroundColor(.green)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(16)
                        } else {
                            Button(action: {}) {
                                Text("Follow")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, 8)
                    
                    Divider()
                    
                    // Dummy Article Content
                    Group {
                        Text("About this topic")
                            .font(.headline)
                        
                        Text("This is a detailed view for the topic/article defined in the Discover section. Here you can see more stories, updates, and in-depth analysis regarding \(article.title).")
                            .font(.body)
                            .lineSpacing(6)
                        
                        Text("Recent Updates")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
                            .font(.body)
                            .lineSpacing(6)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(20)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    DiscoverArticleDetailView(article: DiscoverArticle(
        imageName: "virus_icon",
        title: "Coronavirus COVID-19",
        subtitle: "By euronews en español",
        details: "5,944 viewers • 4,968 stories",
        isFollowing: true,
        color: .blue
    ))
}
