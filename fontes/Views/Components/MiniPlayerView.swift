//
//  MiniPlayerView.swift
//  fontes
//
//  Created by Mateus Costa on 17/12/2025.
//
import SwiftUI


struct PlayerItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let artist: String
    let artwork: String
}

struct MiniPlayerView: View {
    @State private var currentID: UUID?
    
    let items: [PlayerItem] = [
        PlayerItem(title: "Starboy", artist: "The Weeknd", artwork: "current_artwork"),
        PlayerItem(title: "Midnight City", artist: "M83", artwork: "current_artwork"),
        PlayerItem(title: "Get Lucky", artist: "Daft Punk", artwork: "current_artwork")
    ]
    
    var body: some View {
        TabView(selection: $currentID) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                MiniPlayerRow(item: item, index: index + 1)
                    .tag(item.id as UUID?)
                    .padding(.horizontal)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 64)
        .onAppear {
            if currentID == nil {
                currentID = items.first?.id
            }
        }
    }
}

struct MiniPlayerRow: View {
    let item: PlayerItem
    let index: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // Artwork with the new adaptive glow effect
            HStack() {
                
                HStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .frame(width: 16, height: 16)
                        Text("\(index)")
                            .font(.system(size: 10, weight: .bold))
                    }
                    
                    Image(systemName: "play.fill")
                        .font(.system(size: 10, weight: .bold))
                }
                
                Image(item.artwork)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 15, weight: .semibold))
                
                Text(item.artist)
                    .font(.system(size: 13))
            }
            
            Spacer()
            
            // Interaction Group
            HStack(spacing: 20) {
                Button(action: { /* Play/Pause logic */ }) {
                    Image(systemName: "play.fill")
                        .font(.title3)
                }
                
                Button(action: { /* Skip logic */ }) {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                }
            }
        }
        .hoverEffect(.highlight)
    }
}
