//
//  TabAccessoryView.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI
import UIKit

struct TabAccessoryView: View {
    @Namespace private var namespace
    
    var onFilterTap: () -> Void
    var onGoalTap: () -> Void
    var onMiniPlayerTap: ((ReadingItem) -> Void)? = nil
    var hasActiveFilters: Bool = false
    
    var body: some View {
        HStack {
            Spacer().frame(width: 20)
            // Section 1: Mini Player
            MiniPlayerView(onTap: onMiniPlayerTap)
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(1)
            Spacer()
            
            // Section 2: Filter
            TabAccessoryFilter(
                onTap: onFilterTap,
                hasActiveFilters: hasActiveFilters)
                .contentShape(Rectangle()) // Make it easier to tap
            Spacer()
            
            // Section 3: Reading Goal
            TabAccessoryGoal()
                .contentShape(Rectangle()) // Make it easier to tap
            Spacer().frame(width: 20)
        }
        .foregroundColor(.black)

    }
}
