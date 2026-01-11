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
    
    @State private var presentedArticle: ReadingItem? = nil
    @State private var isHeaderVisible: Bool = true
    @State private var showingPageSettings = false
    
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
                    showingPageSettings = true
                },
                onGoalTap: {
                    // TODO: Implement goal action
                    isShowingActions = true
                },
                onMiniPlayerTap: { article in
                    presentedArticle = article
                }
            )
        }
        .sheet(isPresented: $isShowingActions) {
            ActionsView()
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingPageSettings) {
            FeedSettingsView(
                selectedTags: $selectedTags,
                selectedJournalists: $selectedJournalists,
                selectedSources: $selectedSources
            )
        }
        .overlay(alignment: .top) {
            HStack {
                AppLogo()
                
                Spacer()
                
                PageSettings(
                    onFiltersTap: {
                        showingPageSettings = true
                    }
                )
                
                Spacer()
                
                UserSettingsChip(onTap: {
                    // TODO: Handle settings
                })
            }
            .padding(.horizontal, 24)
            .background(.clear)
            .opacity(isHeaderVisible ? 1 : 0)
            .offset(y: isHeaderVisible ? 0 : -100)
            .animation(.easeInOut(duration: 0.3), value: isHeaderVisible)
        }
        .onPreferenceChange(HeaderVisibilityPreferenceKey.self) { visible in
            withAnimation {
                isHeaderVisible = visible
            }
        }
        .fullScreenCover(item: $presentedArticle) { article in
            // Mock next item logic for now, or just show the article
            ReadingDetailView(
                item: article,
                nextItem: nil, // We could calculate this from FeedStore if needed
                onNext: { next in
                    presentedArticle = next
                }
            )
        }
        }
    }
}

