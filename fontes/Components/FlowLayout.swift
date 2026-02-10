//
//  FlowLayout.swift
//  Fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import SwiftUI

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
