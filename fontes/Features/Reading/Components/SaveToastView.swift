//
//  SaveToastView.swift
//  Fontes
//
//  Created by Mateus Costa on 14/01/2026.
//

import SwiftUI

struct SaveToastView: View {
    let onChange: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            
            Text("Guardado para mais tarde")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Button("Mudar") {
                onChange()
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .foregroundColor(.white)
            .glassEffect(.regular.tint(.red).interactive())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .glassEffect(.regular)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        SaveToastView(onChange: {})
    }
}
