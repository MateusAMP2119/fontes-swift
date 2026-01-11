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
        NavigationStack {
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
                LibraryView()
            } label: {
                Label("Library", systemImage: "bookmark")
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
        }
        .sheet(isPresented: $isShowingActions) {
            ActionsView()
                .presentationDetents([.medium])
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                UserSettingsChip(onTap: {
                    // TODO: Handle settings
                })
            }
            .sharedBackgroundVisibility(.hidden)

            ToolbarItem(placement: .topBarTrailing) {
                PageSettings(
                    onFiltersTap: {
                        // TODO: Handle filters
                    }
                )
            }
        }
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        }
    }
}

