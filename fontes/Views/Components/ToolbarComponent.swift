//
//  ToolbarComponent.swift
//  fontes
//
//  Created by Mateus Costa on 19/12/2025.
//

import SwiftUI

struct ToolbarComponent: View {
    @State private var showReadingGoals = false
    @State private var showUserSettings = false

    var body : some View {
        GlassEffectContainer() {
            HStack(spacing: 01.0) {
                HStack(spacing: 02.0) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("12")
                        .font(.system(size: 15, weight: .bold))
                }
                .frame(width: 60.0, height: 40.0)
                .onTapGesture {
                    showReadingGoals = true
                }
                
                Rectangle()
                    .fill(.primary.opacity(0.6))
                    .frame(width: 1, height: 18)

                Image(systemName: "person.crop.circle")
                    .frame(width: 40.0, height: 40.0)
                    .onTapGesture {
                        showUserSettings = true
                    }
            }
        }
        .glassEffect(.regular.tint(.clear).interactive())
        .sheet(isPresented: $showReadingGoals) {
            ReadingGoalsView()
        }
        .sheet(isPresented: $showUserSettings) {
            UserSettingsView()
        }
    }
}

#Preview {
    ToolbarComponent()
}
