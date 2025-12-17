import SwiftUI

struct FriendDetailView: View {
    let friend: Friend
    @State private var selectedBadge: Badge?
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay {
                                Image(systemName: friend.avatar)
                                    .font(.system(size: 50))
                                    .foregroundStyle(.gray)
                            }
                        
                        Text(friend.name)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    // Contribution Graph
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Reading Streak")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 14), spacing: 4) {
                            ForEach(0..<84, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(contributionColor(for: index))
                                    .aspectRatio(1, contentMode: .fit)
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Badges
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Achievements")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                            ForEach(friend.badges) { badge in
                                VStack {
                                    ZStack {
                                        Circle()
                                            .fill(badge.isEarned ? badge.color.opacity(0.2) : Color.gray.opacity(0.1))
                                            .frame(width: 60, height: 60)
                                        
                                        Image(systemName: badge.icon)
                                            .font(.title2)
                                            .foregroundStyle(badge.isEarned ? badge.color : .gray)
                                    }
                                    
                                    Text(badge.name)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(badge.isEarned ? .primary : .secondary)
                                }
                                .opacity(selectedBadge?.id == badge.id ? 0 : (badge.isEarned ? 1.0 : 0.6))
                                .matchedGeometryEffect(id: badge.id, in: namespace)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        selectedBadge = badge
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle(friend.name)
            .navigationBarTitleDisplayMode(.inline)
            
            if let badge = selectedBadge {
                HolographicBadgeView(badge: badge, namespace: namespace) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        selectedBadge = nil
                    }
                }
                .zIndex(1)
            }
        }
    }
    
    // Helper to generate random "heat" colors (reused logic)
    func contributionColor(for index: Int) -> Color {
        let intensity = Int.random(in: 0...4)
        switch intensity {
        case 0: return Color.gray.opacity(0.2)
        case 1: return Color.green.opacity(0.3)
        case 2: return Color.green.opacity(0.5)
        case 3: return Color.green.opacity(0.7)
        default: return Color.green
        }
    }
}

#Preview {
    FriendDetailView(friend: Friend(
        name: "Alice",
        avatar: "person.fill",
        badges: [
            Badge(name: "First Read", icon: "book.fill", color: .blue, isEarned: true, description: "Read your first article."),
            Badge(name: "7 Day Streak", icon: "flame.fill", color: .orange, isEarned: true, description: "Read every day for a week.")
        ]
    ))
}
