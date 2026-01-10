//
//  DiscoverView.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct DiscoverView: View {
    @State private var activeMenuId: String? = nil
    @State private var selectedArticle: DiscoverArticle?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    AppHeader()
                    
                    // Top Result
                    VStack(alignment: .leading, spacing: 12) {
                        Text("TOP RESULT")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    // Topics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("TOPICS")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Button(action: {
                            // Action for see more
                        }) {
                            Text("See more")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .fontWeight(.medium)
                        }
                        .padding(.leading, 40) // Align with title (24 rank width + 16 spacing)
                    }
                    
                    // Sources
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SOURCES")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.purple)
                                .frame(width: 50, height: 50)
                                .overlay(Image(systemName: "map").foregroundColor(.white)) // Placeholder
                            
                            Text("COVID-19 Visualized Through Charts")
                                .font(.headline)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    // Magazines
                    VStack(alignment: .leading, spacing: 12) {
                        Text("MAGAZINES")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            .simultaneousGesture(
                DragGesture().onChanged { _ in
                    if activeMenuId != nil {
                        withAnimation {
                            activeMenuId = nil
                        }
                    }
                }
            )
            .environment(\.activeMenuId, $activeMenuId)
            .fullScreenCover(item: $selectedArticle) { article in
                // Determine next item
                let nextItem: ReadingItem? = {
                    // Flatten list: Top Result + Magazines
                    
                    
                    return nil
                }()
                
                ReadingDetailView(
                    item: article.asReadingItem,
                    nextItem: nextItem,
                    onNext: { nextReadingItem in
                        // Find the corresponding DiscoverArticle to update the selection
                        // This assumes we can find it by ID or matching properties. 
                        // Since 'next' comes from our list, we can search our list again.
                        
                        
                    }
                )
            }
        }
    }
}

#Preview {
    DiscoverView()
}
