//
//  FilterSelectionList.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import SwiftUI

struct FilterSelectionList: View {
    let items: [String]
    @Binding var selectedItems: Set<String>
    let title: String
    var logoProvider: ((String) -> String?)? = nil
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                Button {
                    if selectedItems.contains(item) {
                        selectedItems.remove(item)
                    } else {
                        selectedItems.insert(item)
                    }
                } label: {
                    HStack {
                        if let logoUrl = logoProvider?(item), let url = URL(string: logoUrl) {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image.resizable().aspectRatio(contentMode: .fit)
                                } else {
                                    Color.gray.opacity(0.1)
                                }
                            }
                            .frame(width: 24, height: 24)
                        }
                        
                        Text(item)
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedItems.contains(item) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}
