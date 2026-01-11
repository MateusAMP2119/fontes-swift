//
//  CreateFeedView.swift
//  fontes
//
//  Created by Mateus Costa on 11/01/2026.
//

import SwiftUI

struct CreateFeedView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var feedStore = FeedStore.shared
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var selectedIcon: String = "newspaper"
    @State private var selectedColor: String = "#FF0000"
    
    @State private var selectedSources: Set<String> = []
    @State private var selectedTags: Set<String> = []
    
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
                Section("Feed Details") {
                    TextField("Name", text: $name)
                    TextField("Optional description", text: $description)
                }
                
                Section("Sources") {
                    if feedStore.rssFeeds.isEmpty {
                        Text("No sources available")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(feedStore.rssFeeds) { feed in
                            Toggle(isOn: makeToggleBinding(for: feed.name, in: $selectedSources)) {
                                Text(feed.name)
                            }
                        }
                    }
                }
                
                Section("Tags") {
                    if feedStore.availableTags.isEmpty {
                        Text("No tags available yet")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(feedStore.availableTags, id: \.self) { tag in
                            Toggle(isOn: makeToggleBinding(for: tag, in: $selectedTags)) {
                                Text(tag)
                            }
                        }
                    }
                }
                
                Section("Appearance") {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Icon")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
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
                        
                        Divider()
                        
                        Text("Color")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
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
                    .padding(.vertical, 8)
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
                            colorHex: selectedColor,
                            sources: Array(selectedSources),
                            tags: Array(selectedTags)
                        )
                        onCreate(newFeed)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func makeToggleBinding(for item: String, in set: Binding<Set<String>>) -> Binding<Bool> {
        Binding(
            get: { set.wrappedValue.contains(item) },
            set: { isSelected in
                if isSelected {
                    set.wrappedValue.insert(item)
                } else {
                    set.wrappedValue.remove(item)
                }
            }
        )
    }
}

#Preview {
    CreateFeedView { _ in }
}
