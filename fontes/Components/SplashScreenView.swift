//
//  SplashScreenView.swift
//  Fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

// MARK: - Splash Screen View
struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                AppLogo()
                    .scaleEffect(2.0)
                // Loading spinner
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(1.2)
                    .padding(.top, 32)
            }
        }
    }
}
