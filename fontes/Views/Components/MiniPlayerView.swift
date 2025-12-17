//
//  MiniPlayerView.swift
//  fontes
//
//  Created by Mateus Costa on 17/12/2025.
//
import SwiftUI


struct MiniPlayerView: View {
    
    var body: some View {
        HStack(spacing: 12) {
            // Artwork with the new adaptive glow effect
            Image("current_artwork")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .black.opacity(0.1), radius: 4)
                .adaptiveGlow() // iOS 26: Glow matches artwork palette
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Starboy")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text("The Weeknd")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Interaction Group
            HStack(spacing: 20) {
                Button(action: { /* Play/Pause logic */ }) {
                    Image(systemName: "play.fill")
                        .font(.title3)
                }
                
                Button(action: { /* Skip logic */ }) {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                }
            }
            .foregroundStyle(.primary)
            .padding(.trailing, 4)
        }
        .padding(.all, 8)
        // New interactive spring physics for the "Floating" effect
        .hoverEffect(.highlight)
    }
}

// Extension to handle the iOS 26 Glow aesthetic
extension View {
    func adaptiveGlow() -> some View {
        self.shadow(color: .accentColor.opacity(0.3), radius: 10, x: 0, y: 0)
    }
}
