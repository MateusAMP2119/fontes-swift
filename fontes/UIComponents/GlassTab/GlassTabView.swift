//
//  GlassTabBarView.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct GlassTabView: View {
    @State private var selectedTab = 0
    @State var search: String = ""
    @State private var scrollProgress: Double = 0.0
    @State private var selectedSubTab: TabAccessoryView.TodaySubTab = .tech
    
    var tabAccessoryBinding: Binding<TabAccessoryView.TabItem> {
        Binding<TabAccessoryView.TabItem>(
            get: {
                switch selectedTab {
                case 0: return .today
                case 1: return .forYou
                case 2: return .forLater
                default: return .today
                }
            },
            set: { newItem in
                switch newItem {
                case .today: selectedTab = 0
                case .forYou: selectedTab = 1
                case .forLater: selectedTab = 2
                }
            }
        )
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 0) {
                TodayPage()
            } label: {
                Label("Today", systemImage: "text.rectangle.page")
                    .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
            }
            
            Tab(value: 1) {
                TodayPage()
            } label: {
                Label("For you", systemImage: "paperplane")
                    .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
            }
            
            Tab(value: 2) {
                TodayPage()
            } label: {
                Label("For later", systemImage: "bookmark")
                    .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
            }
            
            Tab(value: 3, role: .search) {
                DiscoverView()
            } label: {
                Label("Discover", systemImage: "magnifyingglass")
            }
        }
        .tint(.red)
        .tabViewBottomAccessory {
            TabAccessoryView(
                scrollProgress: scrollProgress,
                selectedTab: tabAccessoryBinding,
                selectedSubTab: $selectedSubTab,
                onSearchTap: {
                    selectedTab = 3
                }
            )
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}
