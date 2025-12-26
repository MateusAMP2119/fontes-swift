//
//  TabAccessoryPicker.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct TabAccessoryPicker: View {
    @Binding var selectedSort: SortOption
    var isMinimized: Bool = false
    
    enum SortOption: String, CaseIterable {
        case hot = "Destaque"
        case recent = "Novas"
        case trending = "Tendência"
        
        var icon: String {
            switch self {
            case .hot: return "flame"
            case .recent: return "clock"
            case .trending: return "chart.line.uptrend.xyaxis"
            }
        }
    }
    
    var body: some View {
        Picker("Sort Option", selection: $selectedSort) {
            ForEach(SortOption.allCases, id: \.self) { option in
                Group {
                    if isMinimized {
                        Image(systemName: option.icon)
                    } else {
                        Text(option.rawValue)
                    }
                }
                .tag(option)
            }
        }
        .pickerStyle(.segmented)
        .padding(.vertical)
    }
}


#Preview {
    struct PreviewWrapper: View {
        @State var sort = TabAccessoryPicker.SortOption.hot
        
        var body: some View {
            TabAccessoryPicker(selectedSort: $sort)
                .padding()
        }
    }
    return PreviewWrapper()
}
