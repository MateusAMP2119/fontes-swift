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
                
                TabView(selection: $selectedTab) {
                    Tab(value: .today) {
                        TodayView(isSettingsPresented: $isSettingsPresented)
                    } label: {
                        Label("Today", systemImage: "text.rectangle.page")
                            .environment(\.symbolVariants, .none)
                    }
                    
                    Tab(value: .forYou) {
                        ForYouView()
                    } label: {
                        Label("For you", systemImage: "heart.square")
                            .environment(\.symbolVariants, .none)
                    }
                    
                    Tab(value: .forLater) {
                        ForLaterView()
                    } label: {
                        Label("For later", systemImage: "book.pages")
                            .environment(\.symbolVariants, .none)
                    }
                    
                    Tab(value: .search, role: .search) {
                        SearchView()
                            .searchable(text: $searchText)
                    } label: {
                        Label("Discover", systemImage: "sparkle.magnifyingglass")
                            .environment(\.symbolVariants, .none)
                    }
                }
                .tint(Color(red: 252/255, green: 60/255, blue: 68/255))
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
