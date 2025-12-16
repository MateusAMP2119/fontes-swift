//
//  TodayView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct TodayView: View {
    @Binding var isSettingsPresented: Bool
    
    var colors: [Color] = [.yellow, .mint, .teal]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(0..<50) { x in
                        ZStack {
                            Rectangle()
                                .fill(colors.randomElement()?.opacity(0.7) ?? .gray)
                                .frame(width: 350, height: 180)
                            Text("\(x+1)")
                                .foregroundStyle(.white)
                                .fontWeight(.heavy)
                        }
                        .padding()
                    }
                }
            }
            .scrollEdgeEffectStyle(.soft, for: .all)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    GlassTitleView(title: "Today", isSettingsPresented: $isSettingsPresented)
                }
            }
        }
    }
}
#Preview {
    TodayView(isSettingsPresented: .constant(false))
}
