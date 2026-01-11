//
//  AppLogo.swift
//  fontes
//
//  Created by Mateus Costa on 10/01/2026.
//

import SwiftUI

struct AppLogo: View {
    private let redColor = Color.red
    
    var body: some View {
        // Grid-style logo similar to the sketch
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Top left - filled
                Rectangle()
                    .fill(redColor)
                    .frame(width: 16, height: 16)
                
                // Top right - striped/filled
                Rectangle()
                    .fill(redColor)
                    .frame(width: 32, height: 16)
            }
            
            HStack(spacing: 0) {
                // Middle left - lighter red
                Rectangle()
                    .fill(redColor.opacity(0.6))
                    .frame(width: 16, height: 16)
                
                // Middle center - filled
                Rectangle()
                    .fill(redColor)
                    .frame(width: 16, height: 16)
                
                // Middle right - whitish
                Rectangle()
                    .fill(redColor.opacity(0.15))
                    .frame(width: 16, height: 16)
            }
            
            HStack(spacing: 0) {
                // Bottom left - full red
                Rectangle()
                    .fill(redColor)
                    .frame(width: 16, height: 16)
                
                // Bottom right - whitish/light
                Rectangle()
                    .fill(redColor.opacity(0.25))
                    .frame(width: 32, height: 16)
            }
        }
        .background(.white)
        .scaleEffect(0.66)
        .frame(width: 32, height: 32)
    }
}

#Preview {
    AppLogo()
}
