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
                .foregroundColor(.primary)
                .frame(width: 48, height: 48)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PageSettings()
}
