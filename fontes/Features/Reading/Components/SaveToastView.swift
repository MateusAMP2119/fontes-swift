//
//  SaveToastView.swift
//  fontes
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
            
            Text("Saved")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Button("Change") {
                onChange()
            }
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(.blue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .glassEffect(.regular)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        SaveToastView(onChange: {})
    }
}
