//
//  ArticleActionMenu.swift
//  Fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct ArticleActionMenu: View {
    var onSave: () -> Void = {}
    var onMoreLikeThis: () -> Void = {}
    var onBuildAlgorithm: () -> Void = {}
    
    @State private var isExpanded = false
    @State private var activeIndex: Int? = nil // Tracks which button is currently hovered/selected
    
    var showBackground: Bool = true
    
    var menuId: String
    @Environment(\.activeMenuId) var activeMenuId
    
    // Positions for the fan buttons relative to the center
    private let positions: [(x: CGFloat, y: CGFloat)] = [
        (-50, 10),  // Save
        (-40, 55),  // More like this
        (5, 65)     // Build Algorithm
    ]
    
    var body: some View {
        ZStack {
            // Expanded Actions
            if isExpanded {
                FanButton(
                    icon: "bookmark.fill",
                    color: .blue,
                    delay: 0.05,
                    isHighlighted: activeIndex == 0
                ) {
                    performAction(index: 0, action: onSave)
                }
                .offset(x: positions[0].x, y: positions[0].y)
                
                FanButton(
                    icon: "hand.thumbsup.fill",
                    color: .green,
                    delay: 0.1,
                    isHighlighted: activeIndex == 1
                ) {
                    performAction(index: 1, action: onMoreLikeThis)
                }
                .offset(x: positions[1].x, y: positions[1].y)
                
                FanButton(
                    icon: "wand.and.stars",
                    color: .purple,
                    delay: 0.15,
                    isHighlighted: activeIndex == 2
                ) {
                    performAction(index: 2, action: onBuildAlgorithm)
                }
                .offset(x: positions[2].x, y: positions[2].y)
            }
            
            // Trigger Button
            // We use a high-priority Gesture to ensure we capture touches even in a ScrollView/Link
            ZStack {
                if showBackground {
                    Circle()
                        .fill(Material.regular)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                } else {
                    // Larger hit area for touch, but transparent
                    Circle()
                        .fill(Color.white.opacity(0.001))
                        .frame(width: 40, height: 40)
                }
                
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
            }
            .scaleEffect(isDragActive ? 0.9 : 1.0)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isExpanded {
                            // Notify coordination that we are opening
                            activeMenuId.wrappedValue = menuId
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                isExpanded = true
                            }
                        }
                        
                        // Check proximity to buttons
                        let location = value.translation
                        let processedLocation = location
                        // The translation is relative to start point (center of button)
                        // Our button offsets are relative to center as well.
                        
                        // However, DragGesture translation values are valid.
                        // Let's find the closest button
                        var found: Int? = nil
                        for (index, pos) in positions.enumerated() {
                            let dx = processedLocation.width - pos.x
                            let dy = processedLocation.height - pos.y
                            let dist = sqrt(dx*dx + dy*dy)
                            
                            // Hit radius of 30
                            if dist < 35 {
                                found = index
                                break
                            }
                        }
                        
                        if activeIndex != found {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                activeIndex = found
                            }
                            if found != nil {
                                // Optional: Haptic feedback here
                                let impacted = UIImpactFeedbackGenerator(style: .light)
                                impacted.impactOccurred()
                            }
                        }
                    }
                    .onEnded { value in
                        if let index = activeIndex {
                            // Perform action
                            switch index {
                            case 0: performAction(index: 0, action: onSave)
                            case 1: performAction(index: 1, action: onMoreLikeThis)
                            case 2: performAction(index: 2, action: onBuildAlgorithm)
                            default: close()
                            }
                        } else {
                            // Logic for non-selection release
                            let dist = sqrt(value.translation.width*value.translation.width + value.translation.height*value.translation.height)
                            
                            if dist > 20 {
                                // If dragged significantly but not on a button, close
                                close()
                            } else {
                                // Tap behavior (Distance < 20)
                                // We keep it open so user can tap buttons manually if they prefer.
                                // If they want to close, they will likely tap outside or swipe away (handled by swipe away close).
                                // For now, we enforce "Tap to Open / Swipe to Select".
                            }
                        }
                    }
            )
        }
        .onChange(of: activeMenuId.wrappedValue) { oldValue, newValue in
            if newValue != menuId && isExpanded {
                // Another menu opened or background tapped
                isExpanded = false
            }
        }
    }
    
    private var isDragActive: Bool {
        activeIndex != nil
    }
    
    private func performAction(index: Int, action: () -> Void) {
        // Visual feedback
        // Then run action
        action()
        close()
    }
    
    private func close() {
        if isExpanded {
            activeMenuId.wrappedValue = nil // Clear active state
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            isExpanded = false
            activeIndex = nil
        }
    }
}

struct FanButton: View {
    let icon: String
    let color: Color
    let delay: Double
    var isHighlighted: Bool = false
    let action: () -> Void
    
    @State private var appear = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: isHighlighted ? 48 : 36, height: isHighlighted ? 48 : 36)
                    .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 3)
                
                Image(systemName: icon)
                    .font(.system(size: isHighlighted ? 18 : 14, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .scaleEffect(appear ? 1 : 0.1)
        .opacity(appear ? 1 : 0)
        .zIndex(isHighlighted ? 10 : 0) // Bring to front when highlighted
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHighlighted)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(delay)) {
                appear = true
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()
        ArticleActionMenu(menuId: "preview")
    }
}
