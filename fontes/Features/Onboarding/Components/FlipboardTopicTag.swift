//
//  FlipboardTopicTag.swift
//  Fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import SwiftUI

struct FlipboardTopicTag: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("#\(text)")
                .font(.system(size: 16, weight: .bold))
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.flipboardRed : Color(UIColor.systemGray6))
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
