//
//  HolographicBadgeOverlay.swift
//  fontes
//
//  Created by Mateus Costa on 26/12/2025.
//

import SwiftUI

struct HolographicBadgeOverlay: View {
    let badge: Badge
    var namespace: Namespace.ID
    var onDismiss: () -> Void
    
    @State private var shimmerOffset: CGFloat = -0.5
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
                .transition(.opacity)
            
            // Card
            VStack(spacing: 24) {
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(
                            LinearGradient(
                                colors: [badge.color, badge.color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .matchedGeometryEffect(id: "bg-\(badge.id)", in: namespace)
                        .shadow(color: badge.color.opacity(0.5), radius: 20, x: 0, y: 10)
                    
                    // Holographic shine
                    RoundedRectangle(cornerRadius: 32)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: .white.opacity(0.4), location: 0.5),
                                    .init(color: .clear, location: 1)
                                ]),
                                startPoint: UnitPoint(x: 0, y: 0),
                                endPoint: UnitPoint(x: 1, y: 1)
                            )
                        )
                        .rotationEffect(.degrees(45))
                        .offset(x: shimmerOffset * 300)
                        .mask(RoundedRectangle(cornerRadius: 32).matchedGeometryEffect(id: "bg_mask-\(badge.id)", in: namespace))
                    
                    VStack(spacing: 20) {
                        Image(systemName: badge.icon)
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .matchedGeometryEffect(id: "icon-\(badge.id)", in: namespace)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                }
                .frame(width: 280, height: 360)
                
                Text(badge.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .matchedGeometryEffect(id: "text-\(badge.id)", in: namespace)
            }
            .onTapGesture {
                onDismiss()
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                shimmerOffset = 1.5
            }
        }
    }
}
