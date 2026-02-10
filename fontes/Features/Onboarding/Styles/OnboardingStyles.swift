//
//  OnboardingStyles.swift
//  Fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import SwiftUI

struct OnboardingTitleStyle: ViewModifier {
    var size: CGFloat = 32
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .black))
            .textCase(.uppercase)
            .tracking(0.5)
    }
}

struct OnboardingSubtitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.gray)
    }
}

extension View {
    func onboardingTitle(size: CGFloat = 32) -> some View {
        modifier(OnboardingTitleStyle(size: size))
    }
    
    func onboardingSubtitle() -> some View {
        modifier(OnboardingSubtitleStyle())
    }
}
