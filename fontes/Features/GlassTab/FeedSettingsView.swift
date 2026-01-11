//
//  FeedSettingsView.swift
//  fontes
//
//  Created by Mateus Costa on 10/01/2026.
//

import SwiftUI

struct FeedSettingsView: View {
    @ObservedObject var feedStore = FeedStore.shared
    
    @Binding var selectedTags: Set<String>
    @Binding var selectedJournalists: Set<String>
    @Binding var selectedSources: Set<String>
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Manage your content sources and preferences.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                }
                
                Section("Sources") {
                    ForEach($feedStore.feeds) { $feed in
                        Toggle(isOn: $feed.isEnabled) {
                            HStack {
                                AsyncImage(url: URL(string: feed.logoURL)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                
                                Text(feed.name)
                            }
                        }
                        .onChange(of: feed.isEnabled) { _, _ in
                            feedStore.updateFeeds(feedStore.feeds)
                        }
                    }
                }
                
                Section("Content Filters") {
                    NavigationLink {
                        FilterSelectionView(
                            title: "Keywords",
                            items: feedStore.availableTags,
                            selection: $selectedTags
                        )
                    } label: {
                        HStack {
                            Text("Keywords")
                            Spacer()
                            Text("\(selectedTags.count) selected")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    NavigationLink {
                        FilterSelectionView(
                            title: "Journalists",
                            items: feedStore.availableAuthors,
                            selection: $selectedJournalists
                        )
                    } label: {
                        HStack {
                            Text("Journalists")
                            Spacer()
                            Text("\(selectedJournalists.count) selected")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Page Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

struct FilterSelectionView: View {
    let title: String
    let items: [String]
    @Binding var selection: Set<String>
    
    @State private var searchText = ""
    
    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        List {
            if items.isEmpty {
                ContentUnavailableView("No \(title) Available", systemImage: "tray")
            } else {
                ForEach(filteredItems, id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
                        if selection.contains(item) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                                .fontWeight(.bold)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selection.contains(item) {
                            selection.remove(item)
                        } else {
                            selection.insert(item)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search \(title)")
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if !selection.isEmpty {
                    Button("Clear") {
                        selection.removeAll()
                    }
                }
            }
        }
    }
}

#Preview {
    FeedSettingsView(
        selectedTags: .constant([]),
        selectedJournalists: .constant([]),
        selectedSources: .constant([])
    )
}
