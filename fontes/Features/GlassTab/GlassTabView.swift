//
//  GlassTabBarView.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct GlassTabView: View {
    @Namespace private var transition

    @State private var selectedTab = 0
    @State private var previousTab = 0
    @State private var isShowingActions = false
    
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
        .tabBarMinimizeBehavior(.onScrollDown)
        .onChange(of: selectedTab) { oldValue, newValue in
            // Keep the current page and present a sheet when Actions is tapped.
            guard newValue == 3 else {
                previousTab = newValue
                return
            }
            selectedTab = oldValue
            isShowingActions = true
        }
        .tabViewBottomAccessory {
            TabAccessoryView(
                onFilterTap: {
                    // TODO: Implement filter action
                    isShowingActions = true
                },
                onGoalTap: {
                    // TODO: Implement goal action
                    isShowingActions = true
                }
            )
            .matchedTransitionSource(                                            id: "info", in: transition)
        }
        .sheet(isPresented: $isShowingActions) {
            Text("Hello there")
                .presentationDetents([.medium, .large])
                .navigationTransition(
                    .zoom(sourceID: "info", in: transition)
                )
        }
    }
}

