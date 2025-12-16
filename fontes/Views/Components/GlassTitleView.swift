//
//  GlassTitleView.swift
//  fontes
//
//  Created by Mateus Costa on 16/12/2025.
//

import SwiftUI

struct GlassTitleView: View {
    let title: String
    @Binding var isSettingsPresented: Bool
    
    var body: some View {
        HStack() {
            Button {
            } label: {
                Image("fontes_byMarrco")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .glassEffect(
                    .regular.tint(.clear).interactive())
                .frame(width: 100)
            
            Spacer()
            
            Button {
                isSettingsPresented = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.orange)
                        .font(.system(size: 14, weight: .semibold))
                    Text("2")
                        .font(.system(size: 16, weight: .semibold))
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .glassEffect(
                .regular.tint(.clear).interactive())
            .frame(width: 100, alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
        GlassTitleView(title: "Today", isSettingsPresented: .constant(false))
}
