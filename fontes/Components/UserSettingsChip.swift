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
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                )
                .frame(width: 40, height: 40)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    UserSettingsChip()
}
