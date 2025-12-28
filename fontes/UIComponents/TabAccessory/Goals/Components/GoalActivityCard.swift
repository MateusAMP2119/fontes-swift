//
//  GoalActivityCard.swift
//  fontes
//
//  Created by Mateus Costa on 26/12/2025.
//

import SwiftUI

struct GoalActivityCard: View {
    var currentProgressArticles: Int
    
    struct FireAssetConfig {
        let imageName: String
        let mainWidth: CGFloat
        let mainOffset: CGFloat
        let bgWidth: CGFloat
        let bgOffset: (x: CGFloat, y: CGFloat)
    }
    
    var currentAssetConfig: FireAssetConfig {
        switch currentProgressArticles {
        case 0...2:
            return FireAssetConfig(
                imageName: "spark",
                mainWidth: 610,
                mainOffset: 220,
                bgWidth: 1020,
                bgOffset: (x: 0, y: 0)
            )
        case 3...5:
            return FireAssetConfig(
                imageName: "ember",
                mainWidth: 200,
                mainOffset: -20,
                bgWidth: 300,
                bgOffset: (x: 40, y: -38)
            )
        case 6...9:
            return FireAssetConfig(
                imageName: "flame",
                mainWidth: 190,
                mainOffset: -18,
                bgWidth: 290,
                bgOffset: (x: 39, y: -37)
            )
        default:
            return FireAssetConfig(
                imageName: "fire",
                mainWidth: 180,
                mainOffset: -14,
                bgWidth: 280,
                bgOffset: (x: 38, y: -36)
            )
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Objetivos")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                // Activity Card
                ZStack {
                    // The Container
                    HStack(spacing: 0) {
                        // Left: Stats
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(currentProgressArticles)")
                                .foregroundColor(.pink)
                                .font(.system(size: 39, weight: .bold, design: .rounded))
                                .contentTransition(.numericText(value: Double(currentProgressArticles)))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                    .background {
                        ZStack(alignment: .bottomTrailing) {
                            Color(.secondarySystemBackground)
                            
                            let config = currentAssetConfig
                            Image(config.imageName)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: config.bgWidth)
                                .offset(x: config.bgOffset.x, y: config.bgOffset.y)
                                .opacity(0.14)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(alignment: .trailing) {
                        let config = currentAssetConfig
                        Image(config.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: config.mainWidth)
                            .fixedSize()
                            .offset(x: config.mainOffset)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
