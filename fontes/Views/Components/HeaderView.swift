//
//  HeaderView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct HeaderView: View {
    var title: String = "Today"
    @Binding var isSettingsPresented: Bool
    
    var body: some View {
        ZStack {
            HStack {
                // Left: Asset Image
                Image("fontes_byMarrco")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                
                Spacer()
                
                // Right: Stats and Settings
                HStack(spacing: 6) {
                    Button {
                        isSettingsPresented = true
                        print("Stats tapped")
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.orange)
                            Text("2")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                        }

                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .glassEffect(
                    .regular.tint(.clear).interactive()
                )
            }
            
            // Center (Foreground): Dynamic page
            HStack {
                ShortcutMenuView(title: title)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .padding(.leading, 4)
            .glassEffect(
                .regular.tint(.clear).interactive()
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .background(Color.clear)
    }
}

#Preview {
    HeaderView(isSettingsPresented: .constant(false))
}
