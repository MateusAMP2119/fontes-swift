//
//  AlgorithmEditor.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import SwiftUI

struct AlgorithmEditor: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    @State var algorithm: Algorithm
    var onSave: (Algorithm) -> Void
    
    init(title: String, algorithm: Algorithm = Algorithm(name: ""), onSave: @escaping (Algorithm) -> Void) {
        self.title = title
        self._algorithm = State(initialValue: algorithm)
        self.onSave = onSave
    }
    
    // Data reused from FilterExpansion logic
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
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Algorithm Name", text: $algorithm.name)
                }
                
                Section("Filters") {
                    NavigationLink("Tags (\(algorithm.tags.count))") {
                        FilterSelectionList(items: tags, selectedItems: $algorithm.tags, title: "Tags")
                    }
                    NavigationLink("Journalists (\(algorithm.journalists.count))") {
                        FilterSelectionList(items: journalists, selectedItems: $algorithm.journalists, title: "Journalists")
                    }
                    NavigationLink("Sources (\(algorithm.sources.count))") {
                        FilterSelectionList(items: sources, selectedItems: $algorithm.sources, title: "Sources", logoProvider: logo)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !algorithm.name.isEmpty {
                            onSave(algorithm)
                            dismiss()
                        }
                    }
                    .disabled(algorithm.name.isEmpty)
                }
            }
        }
    }
}
