//
//  OnboardingHeader.swift
//  Fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import SwiftUI

struct OnboardingHeader: View {
    var showSkip: Bool = false
    var showLogin: Bool = false
    var onSkip: (() -> Void)? = nil
    var onLogin: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 28)
            
            Spacer()
            
            if showLogin {
                Button(action: { onLogin?() }) {
                    Text("Entrar")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.flipboardRed)
                }
            }
            
            if showSkip {
                Button(action: { onSkip?() }) {
                    Text("Ignorar")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
}
