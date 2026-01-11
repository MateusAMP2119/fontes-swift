//
//  CreateFeedView.swift
//  fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

struct CreateFeedView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var selectedIcon: String = "newspaper"
    @State private var selectedColor: String = "#FF0000"
    
    let onCreate: (Feed) -> Void
    
    private let iconOptions = [
        "newspaper", "cpu", "building.columns", "heart.text.square",
        "chart.line.uptrend.xyaxis", "sportscourt", "music.note",
        "film", "book", "globe", "leaf", "car", "airplane"
    ]
    
    private let colorOptions = [
        "#FF0000", "#FF9500", "#FFCC00", "#34C759",
        "#007AFF", "#5856D6", "#FF2D55", "#AF52DE"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Feed Name") {
                    TextField("Name", text: $name)
                }
                
                Section("Description") {
                    TextField("Optional description", text: $description)
                }
                
                Section("Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                        ForEach(iconOptions, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                Image(systemName: icon)
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(selectedIcon == icon ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedIcon == icon ? Color.accentColor : Color.clear, lineWidth: 2)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                Section("Color") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                        ForEach(colorOptions, id: \.self) { color in
                            Button {
                                selectedColor = color
                            } label: {
                                Circle()
                                    .fill((Color(hex: color) ?? .red).gradient)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("New Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let newFeed = Feed(
                            name: name,
                            description: description.isEmpty ? nil : description,
                            iconName: selectedIcon,
                            colorHex: selectedColor
                        )
                        onCreate(newFeed)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    CreateFeedView { _ in }
}
