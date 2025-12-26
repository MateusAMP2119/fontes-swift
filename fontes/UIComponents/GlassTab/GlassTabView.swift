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
    @State private var sortOption: TabAccessoryView.SortOption = .hot
    @State private var showSortMenu: Bool = false
    @Namespace private var transition
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 0) {
                TodayPage(scrollProgress: $scrollProgress)
            } label: {
                Label("Today", systemImage: "text.rectangle.page")
                    .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
            }
            
            Tab(value: 1) {
                TodayPage(scrollProgress: $scrollProgress)
            } label: {
                Label("For you", systemImage: "paperplane")
                    .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
            }
            
            Tab(value: 2) {
                TodayPage(scrollProgress: $scrollProgress)
            } label: {
                Label("For later", systemImage: "bookmark")
                    .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
            }
            
            Tab(value: 3, role: .search) {
                DiscoverView(scrollProgress: $scrollProgress)
            } label: {
                Label("Discover", systemImage: "magnifyingglass")
            }
        }
        .tint(.red)
        .tabViewBottomAccessory {
            TabAccessoryView(
                selectedSort: $sortOption,
                onFilterTap: { showSortMenu.toggle() },
                readingProgress: scrollProgress,
                isMinimized: scrollProgress > 0.02
            )
            .matchedTransitionSource(
                id: "expansion", in: transition
            )
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .sheet(isPresented: $showSortMenu) {
            Text("Hello, world!")
                .presentationDetents([.medium, .large])
                .navigationTransition(
                    .zoom(sourceID: "expansion", in: transition)
                )
        }
    }
}

