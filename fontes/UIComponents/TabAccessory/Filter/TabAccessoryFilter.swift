//
//  TabAccessoryFilter.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct TabAccessoryFilter: View {
    var onTap: () -> Void
    var hasActiveFilters: Bool = false
    
    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
                
                if hasActiveFilters {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 2, y: -2)
                }
            }
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        TabAccessoryFilter(onTap: { print("Filter tapped") }, hasActiveFilters: false)
        TabAccessoryFilter(onTap: { print("Filter tapped") }, hasActiveFilters: true)
    }
    .padding()
}
