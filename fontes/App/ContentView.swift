//
//  ContentView.swift
//  Fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct ContentView : View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var feedStore = FeedStore.shared

    @State private var isSplashDelayActive = true

    var body: some View {
        ZStack {
            if hasCompletedOnboarding {
                MainNavView()
            } else {
                OnboardingFlowView(isOnboardingCompleted: $hasCompletedOnboarding)
            }
            
            // Show splash screen while initially loading OR while delay is active
            if (feedStore.isInitialLoading || isSplashDelayActive) && hasCompletedOnboarding {
                SplashScreenView()
                    .transition(.opacity)
                    .zIndex(100)
            }
        }
        .task {
            // Start parallel tasks: one for data, one for timer
            await withTaskGroup(of: Void.self) { group in
                // Task 1: Load data
                group.addTask {
                    if hasCompletedOnboarding {
                        await feedStore.loadFeeds()
                    }
                }
                
                // Task 2: Minimum splash duration
                group.addTask {
                    try? await Task.sleep(nanoseconds: 2_500_000_000) // 2.5 seconds
                    await MainActor.run {
                        withAnimation {
                            isSplashDelayActive = false
                        }
                    }
                }
            }
        }
    }
}
