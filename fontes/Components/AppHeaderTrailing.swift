//
//  AppHeaderTrailing.swift
//  fontes
//
//  Created by Mateus Costa on 10/01/2026.
//

import SwiftUI

struct AppHeaderTrailing: View {
    var onSettingsTap: () -> Void = {}
    var onFiltersTap: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 16) {
            // User avatar + settings chip
            UserSettingsChip(onTap: onSettingsTap)
            
            // Filters button
            Button(action: onFiltersTap) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 48, height: 48)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    AppHeaderTrailing()
}
