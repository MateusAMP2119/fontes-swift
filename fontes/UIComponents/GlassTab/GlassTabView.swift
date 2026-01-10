//
//  GlassTabBarView.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct GlassTabView: View {
    @State private var selectedTab = 0
    
    @State private var selectedTags: Set<String> = []
    @State private var selectedJournalists: Set<String> = []
    @State private var selectedSources: Set<String> = []
    
    // Algorithm State
    @State private var selectedAlgorithm: Algorithm? = nil
    @State private var algorithms: [Algorithm] = []
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 0) {
                TodayPage(
                    selectedTags: selectedTags,
                    selectedJournalists: selectedJournalists,
                    selectedSources: selectedSources
                )
            } label: {
                Label("Home", systemImage: "text.rectangle.page")
                    .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
            }
            
            Tab(value: 1) {
                DiscoverView()
            } label: {
                Label("Discover", systemImage: "sparkle.magnifyingglass")
                    .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
            }
            
            Tab(value: 2) {
                TodayPage(
                    selectedTags: selectedTags,
                    selectedJournalists: selectedJournalists,
                    selectedSources: selectedSources
                )
            } label: {
                Label("Library", systemImage: "paperplane")
                    .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
            }
            
            Tab(value: 3, role: .search) {
            } label: {
                Label("Actions", systemImage: "plus")
            }
        }
        .tint(.red)
        .tabViewBottomAccessory {
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

