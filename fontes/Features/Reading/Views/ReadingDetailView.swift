//
//  ArticleDetailView.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import SwiftUI

struct ReadingDetailView: View {
    let item: ReadingItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image Area including Hero Image simulation
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(item.mainColor)
                        .frame(height: 250)
                    
                    LinearGradient(
                        colors: [.black.opacity(0.5), .clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Tags
                        if !item.tags.isEmpty {
                            HStack {
                                ForEach(item.tags, id: \.self) { tag in
                                    Text(tag.uppercased())
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(4)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        Text(item.title)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                    .padding(20)
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    // Meta Info
                    HStack {
                        if let url = URL(string: item.sourceLogo) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Circle().fill(Color.gray.opacity(0.2))
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text(item.author)
                                .font(.headline)
                            Text(item.time)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "bookmark")
                                .font(.title3)
                                .foregroundColor(.primary)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                                .foregroundColor(.primary)
                        }
                        .padding(.leading, 12)
                    }
                    
                    Divider()
                    
                    // Article Body
                    VStack(alignment: .leading, spacing: 16) {
                        Text("This is an immersive reading view for the article titled \"\(item.title)\". In a real application, the full content of the article would be fetched and displayed here.")
                            .font(.body)
                            .lineSpacing(6)
                        
                        Text("Key Highlights")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("• Seamless navigation experience\n• Beautiful typography\n• Distraction-free reading")
                            .font(.body)
                            .lineSpacing(6)
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")
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
