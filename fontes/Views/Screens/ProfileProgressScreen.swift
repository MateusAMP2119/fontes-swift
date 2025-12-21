import SwiftUI

struct ProfileProgressScreen: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var dailyGoal = 5
    
    let badges = [
        Badge(name: "First Read", icon: "book.fill", color: .blue, isEarned: true, description: "Read your first article"),
        Badge(name: "Streak", icon: "flame.fill", color: .orange, isEarned: true, description: "3 day streak"),
        Badge(name: "Scholar", icon: "graduationcap.fill", color: .purple, isEarned: false, description: "Read 100 articles"),
        Badge(name: "Early Bird", icon: "sun.max.fill", color: .yellow, isEarned: false, description: "Read before 8am")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                    // Account Block
                    if userManager.isLoggedIn {
                        loggedInHeader
                    } else {
                        guestAccountCard
                    }
                    
                    // Activity Heatmap
                    ContributionGraph()
                    
                    // Achievements
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Achievements")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(badges) { badge in
                                    VStack {
                                        Circle()
                                            .fill(badge.isEarned ? badge.color.opacity(0.2) : Color.gray.opacity(0.1))
                                            .frame(width: 60, height: 60)
                                            .overlay {
                                                Image(systemName: badge.icon)
                                                    .font(.title2)
                                                    .foregroundColor(badge.isEarned ? badge.color : .gray)
                                            }
                                        
                                        Text(badge.name)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Settings List
                    VStack(spacing: 0) {
                        // Daily Reading Goal
                        HStack {
                            Text("Daily Reading Goal")
                            Spacer()
                            Stepper("", value: $dailyGoal, in: 1...100)
                                .onChange(of: dailyGoal) { _ in Haptics.impact(.light) }
                                .labelsHidden()
                            Text("\(dailyGoal)")
                                .monospacedDigit()
                                .frame(minWidth: 24)
                        }
                        .padding()
                        
                        Divider()
                            .padding(.leading)
                        
                        // Dark Mode
                        Toggle(isOn: $isDarkMode) {
                            Text("Dark Mode")
                        }
                        .onChange(of: isDarkMode) { _ in Haptics.impact(.light) }
                        .padding()
                        
                        Divider()
                            .padding(.leading)
                        
                        // Privacy
                        NavigationLink(destination: Text("Privacy Policy")) {
                            HStack {
                                Text("Privacy")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                    }
                    .background(colorScheme == .dark ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemBackground))
                    .cornerRadius(12)
                }
                .padding()
            }
            .onAppear { Haptics.prepare() }
            .background(colorScheme == .dark ? Color(uiColor: .systemBackground) : Color(uiColor: .secondarySystemBackground))
            .navigationTitle("Profile")
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    private var loggedInHeader: some View {
        HStack {
            if let user = userManager.currentUser {
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Member")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: {
                Haptics.notify(.warning)
                Task {
                    await userManager.logout()
                }
            }) {
                Text("Sign Out")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.red)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemBackground))
        .cornerRadius(12)
    }
    
    private var guestAccountCard: some View {
        VStack(spacing: 16) {
            Text("Sign in to sync your progress and achievements across devices.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
            NavigationLink(destination: AuthView(initialMode: .signup)) {
                Text("Create account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
            }
            .simultaneousGesture(TapGesture().onEnded { Haptics.playTransient() })

            NavigationLink(destination: AuthView(initialMode: .login)) {
                Text("Already have an account?")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .underline()
            }
            .simultaneousGesture(TapGesture().onEnded { Haptics.playTransient() })
            
            HStack {
                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                Text("or use").font(.caption).foregroundColor(.gray)
                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
            }
            
            Button {
                Haptics.playTransient()
                // action for google sign in
            } label: {
                HStack {
                    Image("google_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text("Sign in with Google")
                }
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3),
                                lineWidth: 1))
            }
            
            Button {
                Haptics.playTransient()
                // action for apple sign in
            } label: {
                HStack {
                    Image(systemName: "apple.logo")
                    Text("Sign in with Apple")
                }
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
        }
        .padding(24)
        .background(colorScheme == .dark ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemBackground))
        .cornerRadius(16)
    }
}

struct ProfileProgressScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileProgressScreen()
            .environmentObject(UserManager())
    }
}
