//
//  UserSettingsChip.swift
//  fontes
//
//  Created by Mateus Costa on 10/01/2026.
//

import SwiftUI

struct UserSettingsChip: View {
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action: onTap) {
            // User avatar
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.red, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Text("MC")
                        .font(.system(size: 12, weight: .semibold)) // Reduced font
                        .foregroundColor(.white)
                )
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    UserSettingsChip()
}
