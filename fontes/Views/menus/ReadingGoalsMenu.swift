import SwiftUI

struct ReadingGoalsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var dailyGoal: Int = 5
    @State private var selectedBadge: Badge?
    @Namespace private var namespace
    
    // Mock data for the contribution graph (last 100 days)
    let contributionData: [Bool] = (0..<100).map { _ in Bool.random() }
    
    let badges: [Badge] = [
        Badge(name: "First Read", icon: "book.fill", color: .blue, isEarned: true, description: "Read your first article."),
        Badge(name: "7 Day Streak", icon: "flame.fill", color: .orange, isEarned: true, description: "Read every day for a week."),
        Badge(name: "Bookworm", icon: "eyeglasses", color: .purple, isEarned: false, description: "Read 100 articles."),
        Badge(name: "News Junkie", icon: "newspaper.fill", color: .red, isEarned: false, description: "Read 50 articles in one day."),
        Badge(name: "Early Bird", icon: "sunrise.fill", color: .yellow, isEarned: true, description: "Read an article before 8 AM."),
        Badge(name: "Night Owl", icon: "moon.stars.fill", color: .indigo, isEarned: false, description: "Read an article after 10 PM.")
    ]
    
    let friends: [Friend] = [
        Friend(name: "Sarah", avatar: "person.crop.circle.fill", badges: [
            Badge(name: "First Read", icon: "book.fill", color: .blue, isEarned: true, description: "Read your first article."),
            Badge(name: "Bookworm", icon: "eyeglasses", color: .purple, isEarned: true, description: "Read 100 articles.")
        ]),
        Friend(name: "Mike", avatar: "person.crop.circle.badge.checkmark", badges: [
            Badge(name: "7 Day Streak", icon: "flame.fill", color: .orange, isEarned: true, description: "Read every day for a week."),
            Badge(name: "News Junkie", icon: "newspaper.fill", color: .red, isEarned: true, description: "Read 50 articles in one day.")
        ]),
        Friend(name: "Emma", avatar: "person.crop.circle", badges: [
            Badge(name: "Early Bird", icon: "sunrise.fill", color: .yellow, isEarned: true, description: "Read an article before 8 AM.")
        ])
    ]
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: - Reading Goal Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Daily Reading Goal")
                                .font(.headline)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(dailyGoal) articles")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("per day")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Stepper("", value: $dailyGoal, in: 1...50)
                                    .labelsHidden()
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    
                    // MARK: - Friends Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Friends")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(friends) { friend in
                                    NavigationLink(destination: FriendDetailView(friend: friend)) {
                                        VStack {
                                            Circle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 60, height: 60)
                                                .overlay {
                                                    Image(systemName: friend.avatar)
                                                        .font(.title2)
                                                        .foregroundStyle(.gray)
                                                }
                                            
                                            Text(friend.name)
                                                .font(.caption)
                                                .fontWeight(.medium)
                                                .foregroundStyle(.primary)
                                        }
                                    }
                                }
                                
                                // Add Friend Button
                                Button {
                                    // Action to add friend
                                } label: {
                                    VStack {
                                        Circle()
                                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                            .foregroundStyle(.gray)
                                            .frame(width: 60, height: 60)
                                            .overlay {
                                                Image(systemName: "plus")
                                                    .font(.title2)
                                                    .foregroundStyle(.gray)
                                            }
                                        
                                        Text("Add")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                            
                            // Git-like contribution graph
                            // 7 rows (days of week), scrolling horizontally or just a block
                            // Let's do a simple block of squares for the last few weeks
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
                            
                            HStack {
                                Text("Less")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("More")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Badges Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Achievements")
                                .font(.headline)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                                ForEach(badges) { badge in
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
                .navigationTitle("My Progress")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
            
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
    
    // Helper to generate random "heat" colors
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

#Preview {
    ReadingGoalsView()
}
