//
//  FeaturedCard.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct FeaturedCard: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Main colorful background
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.teal, Color.blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            // Content Overlay
            VStack(alignment: .leading, spacing: 8) {
                Text("Apple's cheapest iPad may be the star of Apple's October event")
                    .font(.system(size: 28, weight: .bold)) // Large title
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                HStack {
                    Text("Macworld")
                        .fontWeight(.semibold)
                    Text("•")
                    Text("3h")
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .shadow(radius: 2)
            }
            .padding(20)
            
            // Top overlays
            VStack {
                HStack(alignment: .top) {
                    // Red Logo Box
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text("F")
                                .font(.system(size: 40, weight: .heavy))
                                .foregroundColor(.white)
                        )
                    
                    Spacer()
                    
                    // Settings Icon
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 20))
                        .padding(10)
                        .background(Color.black.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundColor(.white)
                        .padding(.top, 16)
                        .padding(.trailing, 16)
                }
                Spacer()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
