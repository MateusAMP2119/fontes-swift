//
//  DiscoverTopicRow.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct DiscoverTopicRow: View {
    let rank: Int
    let title: String
    let trend: TopicTrend
    let change: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(rank)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.gray)
                .frame(width: 24, alignment: .leading)
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text(change)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(trendColor)
                
                Image(systemName: trendIconName)
                    .foregroundColor(trendColor)
                    .font(.system(size: 10, weight: .bold))
            }
        }
        .padding(.horizontal)
    }
    
    var trendIconName: String {
        switch trend {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .stable: return "minus"
        }
    }
    
    var trendColor: Color {
        switch trend {
        case .up: return .green
        case .down: return .red
        case .stable: return .gray
        }
    }
}
