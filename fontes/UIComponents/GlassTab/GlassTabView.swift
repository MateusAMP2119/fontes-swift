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
    @State private var showGoalExpansion: Bool = false
    @Namespace private var transition
    
    @State private var selectedTags: Set<String> = []
    @State private var selectedJournalists: Set<String> = []
    @State private var selectedSources: Set<String> = []

    @State private var selectedFolder: String? = nil
    @State private var folders: [String] = ["Read Later", "Favorites", "Tech", "Recipes"]
    
    // Algorithm State
    @State private var selectedAlgorithm: Algorithm? = nil
    @State private var algorithms: [Algorithm] = []
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 0) {
                TodayPage(
                    scrollProgress: $scrollProgress,
                    selectedTags: selectedTags,
                    selectedJournalists: selectedJournalists,
                    selectedSources: selectedSources
                )
            } label: {
                Label("Today", systemImage: "text.rectangle.page")
                    .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
            }
            
            Tab(value: 1) {
                ForYouPage(
                    scrollProgress: $scrollProgress,
                    selectedTags: selectedTags,
                    selectedJournalists: selectedJournalists,
                    selectedSources: selectedSources
                )
            } label: {
                Label("For you", systemImage: "paperplane")
                    .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
            }
            
            Tab(value: 2) {
                ForLaterPage(
                    scrollProgress: $scrollProgress,
                    selectedTags: selectedTags,
                    selectedJournalists: selectedJournalists,
                    selectedSources: selectedSources
                )
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
                activePage: selectedTab,
                selectedSort: $sortOption,
                selectedFolder: $selectedFolder,
                folders: $folders,
                onAddFolder: { name in
                    folders.append(name)
                },
                selectedAlgorithm: $selectedAlgorithm,
                algorithms: $algorithms,
                onAddAlgorithm: { newAlgo in
                    algorithms.append(newAlgo)
                    selectedAlgorithm = newAlgo
                },
                onFilterTap: { showSortMenu.toggle() },
                onGoalTap: { showGoalExpansion.toggle() },
                readingProgress: scrollProgress,
                isMinimized: scrollProgress > 0.02,
                hasActiveFilters: !selectedTags.isEmpty || !selectedJournalists.isEmpty || !selectedSources.isEmpty
            )
            .onChange(of: selectedAlgorithm) { newValue in
                if let algo = newValue {
                    selectedTags = algo.tags
                    selectedJournalists = algo.journalists
                    selectedSources = algo.sources
                } else {
                    // Optional: Clear filters or leave them? 
                    // Usually "Default" implies no filters or a specific set.
                    // For now, if deselected (Default), we might want to clear filters if that's the intended behavior.
                    // But the logic for "Default" wasn't strictly defined.
                    // Assuming "Default" means no algorithm applied -> clear specific filters?
                    // Let's clear them to be safe/consistent with "resetting".
                    selectedTags = []
                    selectedJournalists = []
                    selectedSources = []
                }
            }
            .matchedTransitionSource(
                id: "expansion", in: transition
            )
            .matchedTransitionSource(
                id: "goalExpansion", in: transition
            )
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .sheet(isPresented: $showSortMenu) {
            FilterExpansion(
                selectedTags: $selectedTags,
                selectedJournalists: $selectedJournalists,
                selectedSources: $selectedSources
            )
            .presentationDetents([.medium, .large])
            .navigationTransition(
                .zoom(sourceID: "expansion", in: transition)
            )
        }
        .sheet(isPresented: $showGoalExpansion) {
            GoalExpansion()
                .presentationDetents([.medium, .large])
                .navigationTransition(
                    .zoom(sourceID: "goalExpansion", in: transition)
                )
        }
        .background(Color.white)
        .environment(\.colorScheme, .light)
    }
}

