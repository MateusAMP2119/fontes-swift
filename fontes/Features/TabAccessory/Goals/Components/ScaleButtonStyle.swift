//
//  ScaleButtonStyle.swift
//  fontes
//
//  Created by Mateus Costa on 26/12/2025.
//

import SwiftUI

// Bouncy button style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.88 : 1)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
