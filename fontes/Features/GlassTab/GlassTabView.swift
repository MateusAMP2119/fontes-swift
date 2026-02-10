//
//  GlassTabBarView.swift
//  Fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct GlassTabView: View {
    @Namespace private var transition
    
    @ObservedObject var feedStore = FeedStore.shared

    @State private var selectedTab = 0
    @State private var previousTab = 0
    @State private var isShowingActions = false
    
    @State private var showingPageSettings = false
    @State private var showingFilterSheet = false
    @State private var showUserSettings = false
    
    // Filter State - Now in FeedStore
    // Removed local state variables

    
    // Algorithm State
    @State private var selectedAlgorithm: Algorithm? = nil
    @State private var algorithms: [Algorithm] = []
    
    @State private var presentedArticle: ReadingItem? = nil
    @State private var isHeaderHidden: Bool = false
    @State private var bottomAccessoryHeight: CGFloat = 0
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                Tab(value: 0) {
                    TodayView()
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
                    showingFilterSheet = true
                },
                onGoalTap: {
                    // TODO: Implement goal action
                    isShowingActions = true
                },
                onMiniPlayerTap: { article in
                    presentedArticle = article
                },
                hasActiveFilters: feedStore.hasActiveFilters,
                systemScheme: scheme
            )
            .background(GeometryReader { geometry in
                Color.clear.preference(key: ViewHeightKey.self, value: geometry.size.height)
            })
        }
        .onPreferenceChange(ViewHeightKey.self) { height in
            self.bottomAccessoryHeight = height
        }
        .environment(\.bottomContentHeight, bottomAccessoryHeight)
        .sheet(isPresented: $isShowingActions) {
            ActionsView()
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingPageSettings) {
             ActiveFeedsView()
        }
        .overlay(alignment: .top) {
            HStack {
                AppLogo()
                
                Spacer()
                
                if selectedTab == 0 {
                    PageSettings(
                        onFiltersTap: {
                            showingPageSettings = true
                        }
                    )
                }
                
                Spacer()
                
                
                UserSettingsChip(onTap: {
                    withAnimation {
                        showUserSettings = true
                    }
                })
            }
            .padding(.horizontal, 24)
            .background(.clear)
            .opacity(isHeaderHidden ? 0 : 1)
            .offset(y: isHeaderHidden ? -100 : 0)
            .animation(.easeInOut(duration: 0.25), value: isHeaderHidden)
        }
        .overlay(
            UserSettingsSidebar(isPresented: $showUserSettings)
        )
        .onPreferenceChange(ScrollStatePreferenceKey.self) { hidden in
            withAnimation {
                isHeaderHidden = hidden
            }
        }
        .fullScreenCover(item: $presentedArticle) { article in
            ReadingDetailView(item: article)
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheetView()
        }
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

