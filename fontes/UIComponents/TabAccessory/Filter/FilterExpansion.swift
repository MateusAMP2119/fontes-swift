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

struct FilterSection: View {
    let title: String
    let items: [String]
    @Binding var selectedItems: Set<String>
    var logoProvider: ((String) -> String?)? = nil
    
    @State private var isExpanded = false
    private let limit = 6
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isExpanded {
                    Button(action: {
                        withAnimation {
                            isExpanded = false
                        }
                    }) {
                        Text("Show Less")
                            .font(.subheadline)
                            .underline()
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            FlowLayout(spacing: 12) {
                let visibleItems = isExpanded ? items : Array(items.prefix(limit))
                
                ForEach(visibleItems, id: \.self) { item in
                    FilterChip(
                        text: item,
                        isSelected: selectedItems.contains(item),
                        imageUrl: logoProvider?(item)
                    ) {
                        withAnimation {
                            if selectedItems.contains(item) {
                                selectedItems.remove(item)
                            } else {
                                selectedItems.insert(item)
                            }
                        }
                    }
                }
            }
            
            if !isExpanded && items.count > limit {
                Button(action: {
                    withAnimation {
                        isExpanded = true
                    }
                }) {
                    Text("+ \(items.count - limit) more")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .foregroundColor(.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct FilterChip: View {
    let text: String
    let isSelected: Bool
    var imageUrl: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
                if let imageUrl, let url = URL(string: imageUrl) {
                    // Logo Style
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Color.secondary.opacity(0.1)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Color.secondary.opacity(0.1) // Fallback
                        @unknown default:
                            Color.secondary.opacity(0.1)
                        }
                    }
                    .frame(height: 24) // Fixed height for logos
                    .frame(minWidth: 60) // Ensure reasonable width
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                } else {
                    // Text Style
                    Text(text)
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
            }
            .background(Color.clear)
            .foregroundColor(.primary)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.primary : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// Simple FlowLayout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        if rows.isEmpty { return .zero }
        let totalHeight = rows.reduce(0) { $0 + ($1.maxHeight) } + (CGFloat(rows.count - 1) * spacing)
        return CGSize(width: proposal.width ?? 0, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        
        var yOffset = bounds.minY
        for row in rows {
            var xOffset = bounds.minX
            for item in row.items {
                item.place(at: CGPoint(x: xOffset, y: yOffset), proposal: .unspecified)
                xOffset += item.dimensions(in: .unspecified).width + spacing
            }
            yOffset += row.maxHeight + spacing
        }
    }
    
    struct Row {
        var items: [LayoutSubview]
        var maxHeight: CGFloat
    }
    
    func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var currentRowItems: [LayoutSubview] = []
        var xOffset: CGFloat = 0
        var rowMaxHeight: CGFloat = 0
        let maxWidth = proposal.width ?? 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if xOffset + size.width > maxWidth && !currentRowItems.isEmpty {
                // New row
                rows.append(Row(items: currentRowItems, maxHeight: rowMaxHeight))
                currentRowItems = []
                xOffset = 0
                rowMaxHeight = 0
            }
            
            currentRowItems.append(subview)
            xOffset += size.width + spacing
            rowMaxHeight = max(rowMaxHeight, size.height)
        }
        
        if !currentRowItems.isEmpty {
            rows.append(Row(items: currentRowItems, maxHeight: rowMaxHeight))
        }
        
        return rows
    }
}

#Preview {
    FilterExpansion(
        selectedTags: .constant([]),
        selectedJournalists: .constant([]),
        selectedSources: .constant([])
    )
}
