//
//  GlassTitleView.swift
//  fontes
//
//  Created by Mateus Costa on 16/12/2025.
//

import SwiftUI

struct GlassTitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 16, weight: .semibold))
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .padding(.leading, 4)
            .glassEffect(
                .regular.tint(.clear).interactive()
            )
    }
}

#Preview {
    ZStack {
        Color.blue
        GlassTitleView(title: "Today")
    }
}
