
import SwiftUI

struct UserSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isLoggedIn = false // Mock authentication state

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Profile Section
                Section {
                    if isLoggedIn {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Mateus Costa") // Mock User Name
                                    .font(.headline)
                                Text("mateus@example.com") // Mock Email
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Button("Log Out", role: .destructive) {
                            isLoggedIn = false
                        }
                    } else {
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                Button {
                                    isLoggedIn = true
                                } label: {
                                    Text("Log In")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                                .tint(.primary)
                                
                                Button {
                                    isLoggedIn = true
                                } label: {
                                    Text("Sign Up")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            
                            Button {
                                isLoggedIn = true
                            } label: {
                                Label("Continue with Google", systemImage: "globe")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(.primary)

                            Button {
                                isLoggedIn = true
                            } label: {
                                Label("Continue with Apple", systemImage: "apple.logo")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(.primary)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("Profile")
                }

                // MARK: - Appearance Section
                Section {
                    Toggle(isOn: $isDarkMode) {
                        Label {
                            Text("Dark Mode")
                        } icon: {
                            Image(systemName: "moon.fill")
                                .foregroundColor(.purple)
                        }
                    }
                } header: {
                    Text("Appearance")
                }
                
                // MARK: - General Settings
                Section {
                    NavigationLink {
                        Text("Notifications Settings")
                    } label: {
                        Label("Notifications", systemImage: "bell.badge")
                    }
                    
                    NavigationLink {
                        Text("Privacy Policy")
                    } label: {
                        Label("Privacy", systemImage: "hand.raised")
                    }
                } header: {
                    Text("General")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    UserSettingsView()
}
