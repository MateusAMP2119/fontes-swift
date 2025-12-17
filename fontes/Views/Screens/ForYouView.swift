//
//  ForYouView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct ForYouView: View {
    @State private var selectedAlgorithmId: UUID?
    @State private var isBuildingAlgorithm = false
    
    // Mock Algorithms
    @State private var algorithms: [Algorithm] = [
        Algorithm(name: "Tech Trends", icon: "desktopcomputer", isSelected: true),
        Algorithm(name: "Global Politics", icon: "globe", isSelected: false),
        Algorithm(name: "Healthy Living", icon: "heart.fill", isSelected: false),
        Algorithm(name: "Startup News", icon: "lightbulb.fill", isSelected: false)
    ]
    
    // Mock Data
    let forYouStories: [NewsArticle] = [
        NewsArticle(
            source: "The Verge",
            headline: "Apple announces new AI features for iOS 19",
            timeAgo: "30m ago",
            author: "Nilay Patel",
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1611162617474-5b21e879e113?q=80&w=2574&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/a/a2/The_Verge_logo.svg",
            isTopStory: true,
            tag: "Technology"
        ),
        NewsArticle(
            source: "TechCrunch",
            headline: "This new startup wants to replace your phone with a pin",
            timeAgo: "2h ago",
            author: "Sarah Perez",
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1519389950473-47ba0277781c?q=80&w=2670&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/b/b9/TechCrunch_logo.svg",
            isTopStory: false,
            tag: "Startups"
        ),
        NewsArticle(
            source: "Wired",
            headline: "The future of electric cars is not what you think",
            timeAgo: "4h ago",
            author: nil,
            imageName: "placeholder",
            imageURL: "https://images.unsplash.com/photo-1593941707882-a5bba14938c7?q=80&w=2672&auto=format&fit=crop",
            sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/9/95/Wired_logo.svg",
            isTopStory: false,
            tag: "Transportation"
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        ForYouHeaderView()
                        
                        // Content
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Curated for you")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ForEach(forYouStories) { article in
                                NewsCardView(article: article)
                                    .padding(.horizontal)
                            }
                            
                            // Spacer for the bottom dock
                            Color.clear.frame(height: 100)
                        }
                    }
                }
                .scrollEdgeEffectStyle(.soft, for: .all)
                .background(Color(uiColor: .systemGroupedBackground))
                
                // Floating Pill
                FloatingAlgorithmPill(
                    algorithms: $algorithms,
                    selectedAlgorithmId: $selectedAlgorithmId,
                    onNew: { isBuildingAlgorithm = true }
                )
            }
            .sheet(isPresented: $isBuildingAlgorithm) {
                BuildAlgorithmView()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct Algorithm: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
    var isSelected: Bool
}

struct FloatingAlgorithmPill: View {
    @Binding var algorithms: [Algorithm]
    @Binding var selectedAlgorithmId: UUID?
    var onNew: () -> Void
    
    var currentAlgorithm: Algorithm {
        algorithms.first(where: { $0.id == selectedAlgorithmId }) ?? algorithms.first(where: { $0.isSelected }) ?? algorithms[0]
    }
    
    var body: some View {
        Menu {
            Section("My Algorithms") {
                ForEach(algorithms) { algo in
                    Button {
                        withAnimation {
                            selectedAlgorithmId = algo.id
                            for i in 0..<algorithms.count {
                                algorithms[i].isSelected = (algorithms[i].id == algo.id)
                            }
                        }
                    } label: {
                        if selectedAlgorithmId == algo.id || (selectedAlgorithmId == nil && algo.isSelected) {
                            Label(algo.name, systemImage: "checkmark")
                        } else {
                            Text(algo.name)
                        }
                    }
                }
            }
            
            Section {
                Button(action: onNew) {
                    Label("New Algorithm", systemImage: "plus")
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: currentAlgorithm.icon)
                    .font(.headline)
                Text(currentAlgorithm.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Image(systemName: "chevron.up")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.2), lineWidth: 0.5)
            )
        }
        .padding(.bottom, 20)
    }
}


struct ForYouHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "sparkles")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.blue)
                    .offset(y: -1)
                
                Text("For You")
                    .font(.system(size: 34, weight: .heavy))
                    .kerning(-1.4)
            }
            .foregroundStyle(.primary)
            
            Text("Your personal feed")
                .font(.system(size: 20, weight: .medium, design: .default))
                .foregroundStyle(Color.gray)
                .kerning(-0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}

struct BuildAlgorithmView: View {
    @Environment(\.dismiss) var dismiss
    @State private var algoName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Algorithm Details")) {
                    TextField("Name", text: $algoName)
                }
                
                Section(header: Text("Topics")) {
                    Toggle("Technology", isOn: .constant(true))
                    Toggle("Science", isOn: .constant(false))
                    Toggle("Politics", isOn: .constant(false))
                    Toggle("Design", isOn: .constant(true))
                }
                
                Section(header: Text("Sources")) {
                    Toggle("Major Publications", isOn: .constant(true))
                    Toggle("Independent Blogs", isOn: .constant(true))
                }
            }
            .navigationTitle("New Algorithm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ForYouView()
}
