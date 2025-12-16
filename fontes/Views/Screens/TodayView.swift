//
//  TodayView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct TodayView: View {
    @Binding var isSettingsPresented: Bool
    
    let articles: [NewsArticle] = [
        NewsArticle(
            source: "NBC NEWS",
            headline: "Already-shaky job market weakened in October and November, delayed federal data shows",
            timeAgo: "18m ago",
            author: "Steve Kopack",
            imageName: "placeholder",
            isTopStory: true,
            tag: nil
        ),
        NewsArticle(
            source: "POLITICO",
            headline: "White House weighs risks of a health-care fight as ACA subsidies set to expire",
            timeAgo: "19m ago",
            author: nil,
            imageName: "placeholder",
            isTopStory: false,
            tag: "More politics coverage"
        ),
        NewsArticle(
            source: "apnews.com",
            headline: "Trump administration says White House ballroom construction is a matter of national security",
            timeAgo: "19m ago",
            author: nil,
            imageName: "placeholder",
            isTopStory: false,
            tag: nil
        ),
        NewsArticle(
            source: "ABC NEWS",
            headline: "The last U.S. pennies sell for $16.7 million",
            timeAgo: "19m ago",
            author: "Mason Leath",
            imageName: "placeholder",
            isTopStory: false,
            tag: nil
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        Text("Top Stories")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    ForEach(articles) { article in
                        NewsCardView(article: article)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color(uiColor: .secondarySystemBackground))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    GlassTitleView(title: "Today", isSettingsPresented: $isSettingsPresented)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    TodayView(isSettingsPresented: .constant(false))
}
