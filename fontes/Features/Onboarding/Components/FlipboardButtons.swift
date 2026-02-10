//
//  FlipboardButtons.swift
//  Fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import SwiftUI

struct FlipboardPrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isEnabled ? Color.flipboardRed : Color.gray)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct FlipboardSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct FlipboardTextButtonStyle: ButtonStyle {
    var color: Color = .flipboardRed
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(color)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct FlipboardBackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 48, height: 48)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
        }
    }
}

struct FlipboardContinueButton: View {
    var text: String = "Continuar"
    var isEnabled: Bool = true
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isEnabled ? Color.flipboardRed : Color.gray)
                )
        }
        .disabled(!isEnabled)
    }
}

struct FlipboardKeyboardToolbar: View {
    var showBack: Bool = true
    var showNext: Bool = true
    var backEnabled: Bool = true
    var nextEnabled: Bool = true
    var nextText: String = "Seguinte"
    var onBack: (() -> Void)? = nil
    var onNext: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            if showBack {
                Button(action: { onBack?() }) {
                    Text("Voltar")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(backEnabled ? .white : .gray)
                }
                .disabled(!backEnabled)
            }
            
            Spacer()
            
            if showNext {
                Button(action: { onNext?() }) {
                    Text(nextText)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(nextEnabled ? Color.flipboardRed : Color.gray)
                        )
                }
                .disabled(!nextEnabled)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(UIColor.darkGray))
    }
}
