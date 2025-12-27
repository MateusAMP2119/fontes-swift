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
    
    // Page Context
    var activePage: Int = 0 
    
    // Sort State
    @Binding var selectedSort: SortOption
    
    // Folder State
    @Binding var selectedFolder: String?
    @Binding var folders: [String]
    var onAddFolder: (String) -> Void
    
    // Algorithm State
    @Binding var selectedAlgorithm: Algorithm?
    @Binding var algorithms: [Algorithm]
    var onAddAlgorithm: (Algorithm) -> Void
    
    var onFilterTap: () -> Void
    var onGoalTap: () -> Void
    var readingProgress: Double
    var isMinimized: Bool = false
    var hasActiveFilters: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            // Section 1: Contextual Picker
            if activePage == 2 { // For Later
                TabAccessoryFolderPicker(
                    selectedFolder: $selectedFolder,
                    folders: $folders,
                    onAddFolder: onAddFolder,
                    isMinimized: isMinimized
                )
            } else if activePage == 1 { // For You
                TabAccessoryAlgorithmPicker(
                    selectedAlgorithm: $selectedAlgorithm,
                    algorithms: $algorithms,
                    onAddAlgorithm: onAddAlgorithm,
                    isMinimized: isMinimized
                )
            } else { // Today, etc.
                TabAccessoryPicker(selectedSort: $selectedSort, isMinimized: isMinimized)
            }
            
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
        .background(Color.white)
        .environment(\.colorScheme, .light)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var sort = TabAccessoryView.SortOption.hot
        @State var selectedFolder: String? = nil
        @State var folders = ["Tech", "Design"]
        @State var selectedAlgorithm: Algorithm? = nil
        @State var algorithms: [Algorithm] = []
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                
                TabAccessoryView(
                    activePage: 0,
                    selectedSort: $sort,
                    selectedFolder: $selectedFolder,
                    folders: $folders,
                    onAddFolder: { _ in },
                    selectedAlgorithm: $selectedAlgorithm,
                    algorithms: $algorithms,
                    onAddAlgorithm: { _ in },
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
