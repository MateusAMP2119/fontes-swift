//
//  TabAccessoryAlgorithmPicker.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import SwiftUI

struct TabAccessoryAlgorithmPicker: View {
    @Binding var selectedAlgorithm: Algorithm?
    @Binding var algorithms: [Algorithm]
    var onAddAlgorithm: (Algorithm) -> Void
    var isMinimized: Bool = false
    @Namespace private var transition
    
    @State private var showExpansion = false
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                showExpansion = true
            } label: {
                HStack(spacing: 6) {
                    HStack(spacing: 12) {
                        Image(systemName: selectedAlgorithm == nil ? "sparkles" : "flowchart.fill")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(selectedAlgorithm?.name ?? "Default")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .lineLimit(1)
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(width: 1)
                        .padding(.vertical, 6)
                    
                    Image(systemName: "square.and.pencil")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                }
                .padding(.horizontal, 12)
                .frame(height: 32)
                .background(Color.primary.opacity(0.05))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(Color.gray, lineWidth: 0)
                )
            }
            .matchedTransitionSource(
                id: "algoExpansion", in: transition
            )
            .tint(.primary)
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showExpansion) {
            AlgorithmExpansion(
                selectedAlgorithm: $selectedAlgorithm,
                algorithms: $algorithms,
                onAddAlgorithm: onAddAlgorithm,
                onDeleteAlgorithm: { indexSet in
                    algorithms.remove(atOffsets: indexSet)
                }
            )
            .presentationDetents([.medium, .large])
            .navigationTransition(
                .zoom(sourceID: "algoExpansion", in: transition)
            )
        }
    }
}
