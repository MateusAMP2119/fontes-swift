//
//  SettingsView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        GlassEffectContainer() {
            VStack(alignment: .leading, spacing: 16) {
                Text("Settings")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .glassEffect(
                        .regular.tint(.clear).interactive()
                    )
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color.clear)
    }
}

#Preview {
    SettingsView()
}
