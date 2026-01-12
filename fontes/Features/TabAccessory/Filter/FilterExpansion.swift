//
//  TabAccessoryFilter.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct FilterExpansion: View {
    @Environment(\.dismiss) var dismiss
    
    // Data derived from MockData
    var tags: [String] {
        let allTags = MockData.shared.items.flatMap { $0.tags } + MockData.shared.featuredItem.tags
        return Array(Set(allTags)).sorted()
    }
    
    var journalists: [String] {
        let allAuthors = MockData.shared.items.map { $0.author } + [MockData.shared.featuredItem.author]
        return Array(Set(allAuthors)).sorted()
    }
    
    var sources: [String] {
        let allSources = MockData.shared.items.map { $0.source } + [MockData.shared.featuredItem.source]
        return Array(Set(allSources)).sorted()
    }
    
    // Selection State
    @Binding var selectedTags: Set<String>
    @Binding var selectedJournalists: Set<String>
    @Binding var selectedSources: Set<String>
    
    var totalSelectedCount: Int {
        selectedTags.count + selectedJournalists.count + selectedSources.count
    }
    
    // Helper to get logo URL for a source
    func logo(for source: String) -> String? {
        if let item = MockData.shared.items.first(where: { $0.source == source }) {
            return item.sourceLogo
        }
        if MockData.shared.featuredItem.source == source {
            return MockData.shared.featuredItem.sourceLogo
        }
        return nil
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text("Filters")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if totalSelectedCount > 0 {
                        Text("\(totalSelectedCount)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black)
                            .clipShape(Capsule())
                    }
                }
                
                Spacer()
                
                // Clear button (visible only when filters selected, but keeps layout balanced)
                Button(action: {
                    withAnimation {
                        selectedTags.removeAll()
                        selectedJournalists.removeAll()
                        selectedSources.removeAll()
                    }
                }) {
                    Image(systemName: "eraser")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(totalSelectedCount > 0 ? .primary : .secondary.opacity(0.5))
                        .frame(width: 44, height: 44)
                        .background(totalSelectedCount > 0 ? Color.clear : .gray.opacity(0.1))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                }
                .disabled(totalSelectedCount == 0)
            }
            .padding()
            .padding(.top, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // Tags Section
                    FilterSection(title: "Tags", items: tags, selectedItems: $selectedTags)
                    
                    // Journalists Section
                    FilterSection(title: "Journalists", items: journalists, selectedItems: $selectedJournalists)
                    
                    // Sources Section
                    FilterSection(title: "Sources", items: sources, selectedItems: $selectedSources) { source in
                        logo(for: source)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100) // Space for fixed button
            }        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    FilterExpansion(
        selectedTags: .constant([]),
        selectedJournalists: .constant([]),
        selectedSources: .constant([])
    )
}
