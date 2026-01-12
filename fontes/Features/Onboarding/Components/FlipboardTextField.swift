//
//  FlipboardTextField.swift
//  fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import SwiftUI

struct FlipboardTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 17))
                    .focused($isFocused)
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 17))
                    .focused($isFocused)
            }
            
            Rectangle()
                .fill(isFocused ? Color.flipboardRed : Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.top, 12)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}
