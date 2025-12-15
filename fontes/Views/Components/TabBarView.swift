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
                    Tab("Today", systemImage: "person", value: .today) {
                        TodayView()
                    }
                    
                    Tab("For you", systemImage: "person", value: .forYou) {
                        ForYouView()
                    }
                    
                    Tab("For later", systemImage: "person", value: .forLater) {
                        ForLaterView()
                    }
                    
                    Tab("Discover", systemImage: "magnifyingglass", value: .search, role: .search) {
                        SearchView()
                        .searchable(text: $searchText)
                    }
                }
            }
            
            if isSettingsPresented {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isSettingsPresented = false
                        }
                    }
                
                SettingsView()
                    .padding(.top, 60) // Adjust based on header height
                    .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .topTrailing)))
            }
        }
    }
}

#Preview {
    TabBarView()
}
