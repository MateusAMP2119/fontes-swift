//
//  ContentView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct ContentView : View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            MainNavView()
        } else {
            OnboardingFlowView(isOnboardingCompleted: $hasCompletedOnboarding)
        }
    }
}
