//
//  TabBarView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct TabNavigationWrapper: View {
    @State private var searchText: String = ""
    @State private var selectedTab: TabIdentifier = .today
    @State private var isSettingsPresented = false
    
    @State private var selectedAlgorithmId: UUID?
    @State private var isBuildingAlgorithm = false
    @State private var algorithms: [Algorithm] = [
        Algorithm(name: "Tech Trends", icon: "desktopcomputer", isSelected: true),
        Algorithm(name: "Global Politics", icon: "globe", isSelected: false),
        Algorithm(name: "Healthy Living", icon: "heart.fill", isSelected: false),
        Algorithm(name: "Startup News", icon: "lightbulb.fill", isSelected: false)
    ]
    
    // Today State
    @State private var selectedTodayFilter: TodayFilter = .recent
    
    // For Later State
    @State private var folders: [Folder] = [
        Folder(name: "Read Later", icon: "tray"),
        Folder(name: "Research", icon: "doc.text.magnifyingglass"),
        Folder(name: "Inspiration", icon: "lightbulb")
    ]
    @State private var selectedFolderId: UUID?
    @State private var isCreatingFolder = false
    
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
        NavigationView {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    
                    TabView(selection: $selectedTab) {
                        Tab(value: .today) {
                            TodayView(isSettingsPresented: $isSettingsPresented)
                        } label: {
                            Label("Today", systemImage: "text.rectangle.page")
                                .environment(\.symbolVariants, .none)
                        }
                        
                        Tab(value: .forYou) {
                            ForYouView(algorithms: $algorithms, selectedAlgorithmId: $selectedAlgorithmId)
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
                            DiscoverView()
                        } label: {
                            Label("Discover", systemImage: "sparkle.magnifyingglass")
                                .environment(\.symbolVariants, .none)
                        }
                    }
                    .tint(Color(red: 252/255, green: 60/255, blue: 68/255))
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarComponent()
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
        
    }
}

#Preview {
    TabNavigationWrapper()
}
