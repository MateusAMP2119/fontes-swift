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
        HStack {
            // Left: Asset Image
            Image("fontes_byMarrco")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            Spacer()
            
            // Center: Pill
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGray6)) // Light gray background
                .clipShape(Capsule())
            
            Spacer()
            
            // Right: Icons
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("2")
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .background(Color.white) // Ensure background is set if needed
    }
}

#Preview {
    HeaderView()
}
