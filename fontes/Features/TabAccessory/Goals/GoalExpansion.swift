//
//  GoalExpansion.swift
//  fontes
//
//  Created by Mateus Costa on 26/12/2025.
//

import SwiftUI

struct GoalExpansion: View {
    @Environment(\.dismiss) var dismiss
    
    // User preference for daily goal (in articles) - REMOVED
    
    // Badge Interaction State
    @State private var selectedBadge: Badge?
    @Namespace private var namespace
    
    // Derived progress (mocked for now)
    var currentProgressArticles: Int = 11
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                }
                
                Spacer()
                
                Text("Summary")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Invisible spacer to balance the header
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding()
            .padding(.top, 10)
            
            ScrollView {
                VStack(spacing: 32) {
                    
                    GoalActivityCard(
                        currentProgressArticles: currentProgressArticles
                    )
                    
                    GoalHistoryCalendar()
                    
                    GoalBadgesSection(namespace: namespace, selectedBadge: selectedBadge) { badge in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            selectedBadge = badge
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .background(Color(.systemBackground))
        
        // Holographic Overlay
        if let badge = selectedBadge {
            HolographicBadgeOverlay(badge: badge, namespace: namespace) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    selectedBadge = nil
                }
            }
        }
            
        } // End ZStack
    }
}

#Preview {
    GoalExpansion()
}
