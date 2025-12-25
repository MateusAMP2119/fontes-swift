//
//  TabAccessoryView.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI
import UIKit

struct TabAccessoryView: View {
    var scrollProgress: Double
    @Binding var selectedTab: TabItem
    @Binding var selectedSubTab: TodaySubTab
    var onSearchTap: () -> Void
    
    @Namespace private var namespace
    @State private var hasTriggeredHaptic = false
    
    enum TabItem: String, CaseIterable {
        case today = "Today"
        case forYou = "For You"
        case forLater = "For Later"
        
        var icon: String {
            switch self {
            case .today: return "calendar"
            case .forYou: return "sparkles"
            case .forLater: return "bookmark"
            }
        }
    }
    
    enum TodaySubTab: String, CaseIterable {
        case tech = "Tech"
        case news = "News"
        case culture = "Culture"
        
        var icon: String {
            switch self {
            case .tech: return "desktopcomputer"
            case .news: return "newspaper"
            case .culture: return "theatermasks"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background
                    Color.clear
                    
                    // Gradient Fill
                    LinearGradient(
                        colors: [.blue, .red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: max(0, min(geo.size.width * scrollProgress, geo.size.width)))
                    
                    // Completion State
                    if scrollProgress >= 1.0 {
                        Rectangle()
                            .fill(Color.white)
                            .shadow(color: .white, radius: 4)
                            .blendMode(.overlay)
                            .modifier(PulseEffect())
                    }
                }
            }
            .frame(height: 3)
            
            // Navigation Icons
            HStack(spacing: 16) {
                // Today Section (Expandable)
                HStack(spacing: 8) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = .today
                        }
                    } label: {
                        Image(systemName: TabItem.today.icon)
                            .font(.system(size: 16, weight: selectedTab == .today ? .semibold : .medium))
                            .foregroundColor(selectedTab == .today ? .primary : .secondary)
                    }
                    
                    if selectedTab == .today {
                        HStack(spacing: 4) {
                            ForEach(TodaySubTab.allCases, id: \.self) { sub in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedSubTab = sub
                                    }
                                } label: {
                                    ZStack {
                                        if selectedSubTab == sub {
                                            Capsule()
                                                .fill(Color.secondary.opacity(0.15))
                                                .matchedGeometryEffect(id: "subTabBg", in: namespace)
                                        }
                                        
                                        Image(systemName: sub.icon)
                                            .font(.system(size: 12))
                                            .foregroundColor(selectedSubTab == sub ? .primary : .secondary)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                    }
                                }
                            }
                        }
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
                
                // Other Tabs
                ForEach([TabItem.forYou, TabItem.forLater], id: \.self) { tab in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    } label: {
                        Image(systemName: tab.icon)
                            .font(.system(size: 16, weight: selectedTab == tab ? .semibold : .medium))
                            .foregroundColor(selectedTab == tab ? .primary : .secondary)
                    }
                }
                
                Divider()
                    .frame(height: 16)
                
                // Search Button
                Button {
                    onSearchTap()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        .onChange(of: scrollProgress) { newValue in
            if newValue >= 1.0 {
                if !hasTriggeredHaptic {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    hasTriggeredHaptic = true
                }
            } else {
                hasTriggeredHaptic = false
            }
        }
    }
}

struct PulseEffect: ViewModifier {
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isPulsing ? 0.8 : 0.2)
            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isPulsing)
            .onAppear {
                isPulsing = true
            }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var progress = 0.5
        @State var tab = TabAccessoryView.TabItem.today
        @State var sub = TabAccessoryView.TodaySubTab.tech
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                
                VStack(spacing: 50) {
                    TabAccessoryView(
                        scrollProgress: progress,
                        selectedTab: $tab,
                        selectedSubTab: $sub,
                        onSearchTap: { print("Search") }
                    )
                    
                    Slider(value: $progress, in: 0...1.2)
                        .padding()
                }
            }
        }
    }
    return PreviewWrapper()
}
