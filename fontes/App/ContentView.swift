//
//  ContentView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct ContentView : View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var feedStore = FeedStore.shared

    var body: some View {
        ZStack {
            if hasCompletedOnboarding {
                MainNavView()
            } else {
                OnboardingFlowView(isOnboardingCompleted: $hasCompletedOnboarding)
            }
            
            // Show splash screen while initially loading
            if feedStore.isInitialLoading && hasCompletedOnboarding {
                SplashScreenView()
                    .transition(.opacity)
            }
        }
        .task {
            // Start loading feeds when the app launches
            if hasCompletedOnboarding {
                await feedStore.loadFeeds()
            }
        }
    }
}
