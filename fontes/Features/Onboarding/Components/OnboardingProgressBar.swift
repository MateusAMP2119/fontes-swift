//
//  OnboardingProgressBar.swift
//  fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import SwiftUI

struct OnboardingProgressBar: View {
    var progress: CGFloat // 0.0 to 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 3)
                
                Rectangle()
                    .fill(Color.flipboardRed)
                    .frame(width: geometry.size.width * progress, height: 3)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 3)
    }
}
