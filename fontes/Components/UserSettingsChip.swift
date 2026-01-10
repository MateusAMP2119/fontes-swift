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
                        colors: [.purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Text("M")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                )
                .frame(width: 48, height: 48)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    UserSettingsChip()
}
