//
//  TodayPage.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI
import UIKit

struct TodayView: View {
    // Feed Store
    @ObservedObject private var feedStore = FeedStore.shared
    @Environment(\.bottomContentHeight) private var bottomContentHeight
    
    // Unified data access to handle dynamic filtering
    var filteredContent: (featured: ReadingItem?, list: [ReadingItem]) {
        feedStore.currentDisplayItems
    }
    
    // Featured item
    var featuredItem: ReadingItem? {
        filteredContent.featured
    }
    
    // Sample data for the grid
    var items: [ReadingItem] {
        filteredContent.list
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // Split items into two columns for masonry layout
    var leftColumnItems: [ReadingItem] {
        items.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }
    }
    
    var rightColumnItems: [ReadingItem] {
        items.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element }
    }

    @State private var activeMenuId: String? = nil

    @State private var selectedItem: ReadingItem?
    
    // Toast & Folder Selection
    @State private var showFolderSelection = false
    @State private var itemForFolderSelection: ReadingItem?

    var body: some View {
        ScrollView {
            Spacer().frame(height: 44)
            
            VStack(spacing: 0) {
                    // Offline indicator banner
                    if let statusMessage = feedStore.statusMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "wifi.slash")
                            .font(.caption)
                            Text(statusMessage)
                            .font(.caption)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                    }
                    
                    if feedStore.isLoading && feedStore.items.isEmpty {
                        // Loading state
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Loading articles...")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 400)
                    } else if let error = feedStore.error, feedStore.items.isEmpty {
                        // Error state
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)
                            Text("Failed to load articles")
                                .font(.headline)
                            Text(error.localizedDescription)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Button("Try Again") {
                                Task {
                                    await feedStore.refresh()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity, minHeight: 400)
                    } else {
                        VStack(spacing: 24) {
                            // Featured Card
                            if let featuredItem = featuredItem {
                                    FeaturedCard(item: featuredItem)
                                        .frame(height: 400)
                                        .transition(.scale.combined(with: .opacity))
                                        .contentShape(Rectangle()) // Ensure tap target is good
                                        .onTapGesture {
                                            selectedItem = featuredItem
                                        }
                            }
                            
                            // Masonry Grid
                            HStack(alignment: .top, spacing: 16) {
                                // Left Column
                                LazyVStack(spacing: 24) {
                                    ForEach(leftColumnItems) { item in
                                        GridCard(item: item)
                                            .transition(.scale.combined(with: .opacity))
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                selectedItem = item
                                            }
                                        .onAppear {
                                            // Aggressive Prefetching Trigger (Left)
                                            // Trigger when we are 15 items away from the end
                                            if let index = items.firstIndex(where: { $0.id == item.id }),
                                               index >= items.count - 15 {
                                                Task {
                                                    await feedStore.loadMore()
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                // Right Column
                                LazyVStack(spacing: 24) {
                                    ForEach(rightColumnItems) { item in
                                        GridCard(item: item)
                                            .transition(.scale.combined(with: .opacity))
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                selectedItem = item
                                            }
                                        .onAppear {
                                            // Aggressive Prefetching Trigger (Right)
                                            // Trigger when we are 15 items away from the end
                                            if let index = items.firstIndex(where: { $0.id == item.id }),
                                               index >= items.count - 15 {
                                                Task {
                                                    await feedStore.loadMore()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Infinite Scroll Loading Indicator & Trigger
                            if feedStore.canLoadMore {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .id(UUID()) // Force redraw to ensure onAppear fires if needed
                                        .onAppear {
                                            Task {
                                                await feedStore.loadMore()
                                            }
                                        }
                                    Spacer()
                                }
                                .padding(.vertical, 32)
                            }
                        }

                        .padding(.horizontal)
                        .animation(.default, value: items.map { $0.id })
                        .animation(.default, value: featuredItem?.id)
                    }
                }
            }
        .onScrollHideHeader()
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            if value > 100 && !feedStore.isLoading {
                Task {
                    // Haptic feedback
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    await feedStore.refresh()
                }
            }
        }
        .task {
            // Preload cached data first for instant display
            await feedStore.preloadCachedData()
            // Then try to fetch fresh data from network
            await feedStore.loadFeeds()
        }
        .fullScreenCover(item: $selectedItem) { item in
            ReadingDetailView(item: item)
        }
        .overlay(alignment: .bottom) {
            if feedStore.showingSaveToast {
                SaveToastView {
                    // On Change
                    if let item = feedStore.lastSavedItem {
                        itemForFolderSelection = item
                        showFolderSelection = true
                        // Hide toast
                        withAnimation {
                            feedStore.showingSaveToast = false
                        }
                    }
                }
                .padding(.bottom, bottomContentHeight + 10) // Dynamic positioning
                .transition(.scale(scale: 0.8).combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showFolderSelection) {
            if let item = itemForFolderSelection {
                FolderSelectionView(item: item)
            }
        }
    }
}


struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}

