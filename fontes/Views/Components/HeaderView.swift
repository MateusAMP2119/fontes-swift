//
//  HeaderView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct HeaderView: View {
    var title: String = "Today"
    
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
                Button {
                    print("Right pill tapped")
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.orange)
                        Text("2")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.black)
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 1, height: 14)
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                    .contentShape(Rectangle())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .glassEffect(
                        .regular.tint(.clear).interactive()
                    )
                }
                .buttonStyle(.plain)
            }
            
            // Center (Foreground): Dynamic page
            Button {
                print ("Center pill tapped")
            } label: {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                }
                .contentShape(Rectangle())
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .glassEffect(
                    .regular.tint(.clear).interactive()
                )
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .background(Color.clear)
    }
}

#Preview {
    HeaderView()
}
