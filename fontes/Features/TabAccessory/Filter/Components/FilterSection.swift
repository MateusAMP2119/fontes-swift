//
//  FilterSection.swift
//  fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import SwiftUI

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
