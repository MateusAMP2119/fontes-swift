//
//  FilterSheetView.swift
//  Fontes
//
//  Created by Mateus Costa on 15/01/2026.
//

import SwiftUI

struct FilterSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    @ObservedObject var feedStore = FeedStore.shared
    
    // Data derived from FeedStore
    var tags: [String] {
        let allTags = feedStore.availableTags
        return sortItems(allTags, selected: feedStore.activeTags)
    }
    
    var journalists: [String] {
        let allAuthors = feedStore.availableAuthors
        return sortItems(allAuthors, selected: feedStore.activeAuthors)
    }
    
    var sources: [String] {
        let allSources = feedStore.availableSources
        return sortItems(allSources, selected: feedStore.activeSources)
    }
    
    // Selection State - Using FeedStore directly
    var selectedTags: Binding<Set<String>> {
        $feedStore.activeTags
    }
    
    var selectedJournalists: Binding<Set<String>> {
        $feedStore.activeAuthors
    }
    
    var selectedSources: Binding<Set<String>> {
        $feedStore.activeSources
    }
    
    var totalSelectedCount: Int {
        feedStore.activeTags.count + feedStore.activeAuthors.count + feedStore.activeSources.count
    }
    
    // Helper to get logo URL for a source
    func logo(for source: String) -> String? {
        // Try to find logo in available RSS feeds configuration first
        if let feed = feedStore.rssFeeds.first(where: { $0.name == source }) {
            return feed.logoURL
        }
        // Fallback to finding it in items
        if let item = feedStore.items.first(where: { $0.source == source }) {
            return item.sourceLogo
        }
        return nil
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header similar to ActiveFeedsView
            HStack {
                HStack(spacing: 8) {
                    Text("Filtros")
                        .font(.title).bold()
                    
                    if totalSelectedCount > 0 {
                        Text("\(totalSelectedCount)")
                            .contentTransition(.numericText(value: Double(totalSelectedCount)))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .clipShape(Capsule())
                            .transition(.scale.animation(.bouncy))
                    }
                }
                .animation(.bouncy, value: totalSelectedCount)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        selectedTags.wrappedValue.removeAll()
                        selectedJournalists.wrappedValue.removeAll()
                        selectedSources.wrappedValue.removeAll()
                    }
                }) {
                    Image(systemName: "eraser.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.gray)
                        .frame(width: 32, height: 32)
                }
                .glassEffect(.regular.interactive())
                .clipShape(Circle())
                .disabled(totalSelectedCount == 0)
                .opacity(totalSelectedCount > 0 ? 1 : 0.3)
                .padding(.trailing, 8)
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.gray)
                        .frame(width: 32, height: 32)
                }
                .glassEffect(.regular.interactive())
                .clipShape(Circle())
            }
            .padding(.horizontal, 26)
            .padding(.top, 24)
            .padding(.bottom, 16)
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Pesquisar", text: $searchText)
                    .onSubmit {
                        selectFirstResult()
                    }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            ScrollView {
                if searchText.isEmpty {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // Tags Section
                        FilterSection(title: "Categorias", items: tags, selectedItems: selectedTags)
                        
                        // Journalists Section
                        FilterSection(title: "Escritories", items: journalists, selectedItems: selectedJournalists)
                        
                        // Sources Section
                        FilterSection(title: "Jornais", items: sources, selectedItems: selectedSources) { source in
                            logo(for: source)
                        }
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 100) // Space for fixed button/safe area
                } else {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(tags, id: \.self) { tag in
                            Button {
                                toggleSelection(for: tag, in: selectedTags)
                            } label: {
                                SearchResultRow(title: tag, type: "Categoria", isSelected: feedStore.activeTags.contains(tag))
                            }
                        }
                        
                        ForEach(journalists, id: \.self) { journalist in
                            Button {
                                toggleSelection(for: journalist, in: selectedJournalists)
                            } label: {
                                SearchResultRow(title: journalist, type: "Escritor", isSelected: feedStore.activeAuthors.contains(journalist))
                            }
                        }
                        
                        ForEach(sources, id: \.self) { source in
                            Button {
                                toggleSelection(for: source, in: selectedSources)
                            } label: {
                                SearchResultRow(title: source, type: "Jornal", isSelected: feedStore.activeSources.contains(source), imageUrl: logo(for: source))
                            }
                        }
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 100)
                }
            }
        }
        .background(Color.white)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
    
    // MARK: - Helpers
    
    private func toggleSelection(for item: String, in set: Binding<Set<String>>) {
        withAnimation {
            if set.wrappedValue.contains(item) {
                set.wrappedValue.remove(item)
            } else {
                set.wrappedValue.insert(item)
            }
            // Auto-close search on selection
            searchText = ""
        }
    }
    
    private func sortItems(_ items: [String], selected: Set<String>) -> [String] {
        let filteredIfNeeded: [String]
        if searchText.isEmpty {
            filteredIfNeeded = items
        } else {
            filteredIfNeeded = items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filteredIfNeeded.sorted { (item1, item2) -> Bool in
            let isSelected1 = selected.contains(item1)
            let isSelected2 = selected.contains(item2)
            
            if isSelected1 != isSelected2 {
                return isSelected1 // Selected items come first
            }
            return item1 < item2 // Then alphabetical
        }
    }

    private func selectFirstResult() {
        if let firstTag = tags.first {
            toggleSelection(for: firstTag, in: selectedTags)
        } else if let firstJournalist = journalists.first {
            toggleSelection(for: firstJournalist, in: selectedJournalists)
        } else if let firstSource = sources.first {
            toggleSelection(for: firstSource, in: selectedSources)
        }
    }
}

struct SearchResultRow: View {
    let title: String
    let type: String
    let isSelected: Bool
    var imageUrl: String? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .foregroundColor(.primary)
                
                Text(type)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        Divider()
    }
    
    #Preview {
        FilterSheetView()
    }
}
