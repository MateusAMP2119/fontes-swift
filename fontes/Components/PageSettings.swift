//
//  AppHeaderTrailing.swift
//  fontes
//
//  Created by Mateus Costa on 10/01/2026.
//

import SwiftUI

struct PageSettings: View {
    var onFiltersTap: () -> Void = {}
    
    var body: some View {
        // Setting button
        Button(action: onFiltersTap) {
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 20, weight: .medium))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .glassEffect()
    }
}

#Preview {
    PageSettings()
}
