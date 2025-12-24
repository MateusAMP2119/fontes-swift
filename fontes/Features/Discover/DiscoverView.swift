//
//  DiscoverView.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct DiscoverView: View {
    @State var search: String = ""

    @State private var selectedTab = "ALL"
    
    let tabs = ["ALL", "TOPICS", "MAGAZINES", "PROFILES", "SOCIAL"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        ForEach(tabs, id: \.self) { tab in
                            VStack(spacing: 8) {
                                Text(tab)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(selectedTab == tab ? .red : .gray)
                                
                                Rectangle()
                                    .fill(selectedTab == tab ? Color.red : Color.clear)
                                    .frame(height: 2)
                            }
                            .onTapGesture {
                                selectedTab = tab
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
                
                Divider()
                
                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Top Result
                        VStack(alignment: .leading, spacing: 12) {
                            Text("TOP RESULT")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            DiscoverResultRow(
                                imageName: "virus_icon", // Placeholder
                                title: "Coronavirus COVID-19",
                                subtitle: "By euronews en español",
                                details: "5,944 viewers • 4,968 stories",
                                isFollowing: true
                            )
                        }
                        .padding(.top)
                        
                        // Topics
                        VStack(alignment: .leading, spacing: 12) {
                            Text("TOPICS")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            DiscoverTopicRow(title: "#Coronavirus (COVID-19)")
                            DiscoverTopicRow(title: "#Health (India)")
                        }
                        
                        // Sources
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SOURCES")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            HStack(spacing: 12) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .overlay(Image(systemName: "map").foregroundColor(.gray)) // Placeholder
                                
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
                            
                            DiscoverResultRow(
                                imageName: "vaccine_icon",
                                title: "The Latest on Coronavirus...",
                                subtitle: "By The News Desk",
                                details: "1.2M viewers • 11,293 stories",
                                isFollowing: false
                            )
                            
                            DiscoverResultRow(
                                imageName: "flag_icon",
                                title: "Coronavirus: COVID-19",
                                subtitle: "By CaliGypsyGurl",
                                details: "1.2M viewers • 11,293 stories",
                                isFollowing: false
                            )
                        }
                    }
                    .padding(.bottom)
                    .searchable(
                                    text: $search,
                                    placement: .toolbar, // Integrates with the glass navigation bar
                                    prompt: "Type here to search"
                                )
                }
            }
        }
    }
}

struct DiscoverResultRow: View {
    let imageName: String
    let title: String
    let subtitle: String
    let details: String
    let isFollowing: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Image Placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
                .cornerRadius(4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(details)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {}) {
                Text(isFollowing ? "Following" : "Follow")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isFollowing ? .gray : .white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(isFollowing ? Color.gray.opacity(0.2) : Color.red)
                    .cornerRadius(4)
            }
        }
        .padding(.horizontal)
    }
}

struct DiscoverTopicRow: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Button(action: {}) {
                Text("Follow")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red)
                    .cornerRadius(4)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    DiscoverView()
}
