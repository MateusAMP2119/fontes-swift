//
//  GoalBadgesSection.swift
//  fontes
//
//  Created by Mateus Costa on 26/12/2025.
//

import SwiftUI

// Badges Section Component
struct GoalBadgesSection: View {
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    var namespace: Namespace.ID
    var selectedBadge: Badge?
    var onTap: (Badge) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Badges")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(mockBadges) { badge in
                    VStack(spacing: 8) {
                        ZStack {
                            if selectedBadge?.id != badge.id {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: badge.isEarned
                                            ? [badge.color, badge.color.opacity(0.6)]
                                            : [Color.gray.opacity(0.3), Color.gray.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 70, height: 70)
                                    .shadow(
                                        color: badge.isEarned ? badge.color.opacity(0.3) : .clear,
                                        radius: 5, x: 0, y: 3
                                    )
                                    .matchedGeometryEffect(id: "bg-\(badge.id)", in: namespace)
                                
                                Image(systemName: badge.icon)
                                    .font(.system(size: 30))
                                    .foregroundColor(badge.isEarned ? .white : .gray)
                                    .matchedGeometryEffect(id: "icon-\(badge.id)", in: namespace)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 70, height: 70)
                            }
                        }
                        .onTapGesture {
                            onTap(badge)
                        }
                        
                        if selectedBadge?.id != badge.id {
                            Text(badge.name)
                                .font(.caption)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .foregroundColor(badge.isEarned ? .primary : .secondary)
                                .matchedGeometryEffect(id: "text-\(badge.id)", in: namespace)
                        } else {
                            Text(badge.name)
                                .font(.caption)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.clear)
                        }
                    }
                }
            }
            .padding(20)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding(.horizontal)
        }
    }
}
