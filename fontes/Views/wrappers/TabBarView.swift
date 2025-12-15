//
//  TabBarView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct TabBarView: View {
    @State private var searchText: String = ""
    @State private var selectedTab: TabIdentifier = .today
    @State private var isSettingsPresented = false
    
    enum TabIdentifier: String, CaseIterable {
        case today, forYou, forLater, search
        
        var title: String {
            switch self {
            case .today: return "Today"
            case .forYou: return "For You"
            case .forLater: return "For Later"
            case .search: return "Discover"
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                HeaderView(title: selectedTab.title, isSettingsPresented: $isSettingsPresented)
                    .zIndex(1)
                
                TabView(selection: $selectedTab) {
                    Tab("Today", systemImage: "text.rectangle.page", value: .today) {
                        TodayView()
                    }
                    
                    Tab("For you", systemImage: "person", value: .forYou) {
                        ForYouView()
                    }
                    
                    Tab("For later", systemImage: "bookmark", value: .forLater) {
                        ForLaterView()
                    }
                    
                    Tab("Discover", systemImage: "magnifyingglass", value: .search, role: .search) {
                        SearchView()
                        .searchable(text: $searchText)
                    }
                }
            }
            
        }
        .sheet(isPresented: $isSettingsPresented) {
            UserSettingsView()
        }
    }
}

#Preview {
    TabBarView()
}
