import SwiftUI

// 1. Define a simplistic Route enum to manage where we can go
enum SettingsRoute: Hashable {
    case createAccount
    case login
    case privacy
}

struct UserSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    // 2. Add a State for programmatic navigation (Optional, but good for deep linking)
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            Form {
                // MARK: - Profile Section
                Section {
                    VStack(spacing: 16) {
                        
                        // Refactored: Standard Button, Navigation handled below
                        Button {
                            path.append(SettingsRoute.createAccount)
                        } label: {
                            Text("Create account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain) // Removes default list row styling
                        
                        // Refactored: Text Button
                        Button {
                            path.append(SettingsRoute.login)
                        } label: {
                            Text("Already have an account?")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .underline()
                        }
                        .buttonStyle(.plain)

                        HStack {
                            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                            Text("or use").font(.caption).foregroundColor(.gray)
                            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                        }
                        
                        Button {
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
                    .padding(.vertical, 8)
                } header: {
                    Text("Profile")
                }

                // MARK: - Preferences Section
                Section {
                    NavigationLink(destination: Text("Reading Goals Settings")) {
                        Label("Reading Goals", systemImage: "target")
                    }
                    NavigationLink(destination: Text("Notification Settings")) {
                        Label("Notifications", systemImage: "bell")
                    }
                } header: {
                    Text("Preferences")
                }

                // MARK: - Appearance Section
                Section {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.primary)
                            .contentTransition(.symbolEffect(.replace))
                    }
                } header: {
                    Text("Appearance")
                }
                
                // MARK: - General Settings
                Section("General") {
                    NavigationLink(value: SettingsRoute.privacy) {
                        Label("Privacy", systemImage: "hand.raised")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", role: .cancel) { dismiss() }
                }
            }
            // 3. CENTRALIZED NAVIGATION DESTINATIONS
            // This is the "Switchboard" for your view
            .navigationDestination(for: SettingsRoute.self) { route in
                switch route {
                case .createAccount:
                    CreateAccountView()
                case .login:
                    LoginView()
                case .privacy:
                    Text("Privacy Policy")
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
