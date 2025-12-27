//
//  TabAccessoryView.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI
import UIKit

struct TabAccessoryView: View {
    typealias SortOption = TabAccessoryPicker.SortOption
    
    @Binding var selectedSort: SortOption
    var onFilterTap: () -> Void
    var onGoalTap: () -> Void
    var readingProgress: Double
    var isMinimized: Bool = false
    var hasActiveFilters: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            // Section 1: Sorting Picker
            TabAccessoryPicker(selectedSort: $selectedSort, isMinimized: isMinimized)
            // Section 2: Filter
            TabAccessoryFilter(onTap: onFilterTap, hasActiveFilters: hasActiveFilters)
            Spacer()
            // Section 3: Reading Goal
            TabAccessoryGoal(progress: readingProgress)
                .contentShape(Rectangle()) // Make it easier to tap
                .onTapGesture {
                    onGoalTap()
                }
        }
        .padding(.vertical)
        .padding(.horizontal, 6)
        .background(Color(.systemBackground))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var sort = TabAccessoryView.SortOption.hot
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                
                TabAccessoryView(
                    selectedSort: $sort,
                    onFilterTap: { print("Filter") },
                    onGoalTap: { print("Goal") },
                    readingProgress: 0.6
                )
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
