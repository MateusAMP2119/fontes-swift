//
//  AppHeader.swift
//  fontes
//
//  Created by Mateus Costa on 10/01/2026.
//

import SwiftUI

struct AppHeader: View {
    var onSettingsTap: () -> Void = {}
    var onFiltersTap: () -> Void = {}
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Logo on the left
            AppLogo()
            
            Spacer()
            
            // Right side controls
            HStack(spacing: 12) {
                // User avatar + settings chip
                UserSettingsChip(onTap: onSettingsTap)
                
                // Filters button
                Button(action: onFiltersTap) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - App Logo
struct AppLogo: View {
    private let redColor = Color.red
    
    var body: some View {
        // Grid-style logo similar to the sketch
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Top left - filled
                Rectangle()
                    .fill(redColor)
                    .frame(width: 12, height: 12)
                
                // Top right - striped/filled
                Rectangle()
                    .fill(redColor)
                    .frame(width: 24, height: 12)
            }
            
            HStack(spacing: 0) {
                // Middle left - lighter red
                Rectangle()
                    .fill(redColor.opacity(0.6))
                    .frame(width: 12, height: 12)
                
                // Middle center - filled
                Rectangle()
                    .fill(redColor)
                    .frame(width: 12, height: 12)
                
                // Middle right - whitish
                Rectangle()
                    .fill(redColor.opacity(0.15))
                    .frame(width: 12, height: 12)
            }
            
            HStack(spacing: 0) {
                // Bottom left - full red
                Rectangle()
                    .fill(redColor)
                    .frame(width: 12, height: 12)
                
                // Bottom right - whitish/light
                Rectangle()
                    .fill(redColor.opacity(0.25))
                    .frame(width: 24, height: 12)
            }
        }
        .frame(width: 36, height: 36)
    }
}

// MARK: - User Settings Chip
struct UserSettingsChip: View {
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                // User avatar
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                    .overlay(
                        Text("M")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    )
                
                // Gear icon
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 6)
            .padding(.trailing, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        AppHeader()
        Spacer()
    }
}
