//
//  TabBarView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "person")
                }

            ForYouView()
                .tabItem {
                    Label("For You", systemImage: "sparkles")
                }
            ForLaterView()
                .tabItem {
                    Label("For Later", systemImage: "bookmark")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    TabBarView()
}
