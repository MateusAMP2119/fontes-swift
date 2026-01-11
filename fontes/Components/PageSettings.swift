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
            Text("Para ti")
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.primary)

            Spacer().frame(width: 8)

            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 16, weight: .medium))
            .frame(width: 32, height: 32)
            .contentShape(Rectangle())
            .foregroundColor(.primary)
        }
        .padding(.leading, 12)
        .padding(.trailing, 8)
        .glassEffect()
    }
}

#Preview {
    PageSettings()
}
