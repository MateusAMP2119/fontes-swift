//
//  Toolbar.swift
//  fontes
//
//  Created by Mateus Costa on 19/12/2025.
//

import SwiftUI

struct ToolbarComponent: View {
    var body : some View {
        GlassEffectContainer(spacing: 20.0) {
            HStack(spacing: 20.0) {
                HStack(spacing: 2) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("12")
                        .font(.system(size: 15, weight: .bold))
                }
                .frame(width: 60.0, height: 40.0)
                .glassEffect(.regular.tint(.clear).interactive())

                Image(systemName: "person.crop.circle")
                    .frame(width: 40.0, height: 40.0)
                    .glassEffect(.regular.tint(.clear).interactive())


                    // An `offset` shows how Liquid Glass effects react to each other in a container.
                    // Use animations and components appearing and disappearing to obtain effects that look purposeful.
                    .offset(x: -20.0, y: 0.0)
            }
        }
        .offset(x: 20.0)
    }
}

#Preview {
    ToolbarComponent()
}
