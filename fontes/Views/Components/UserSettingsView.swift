
import SwiftUI

struct UserSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false



    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Profile Section
                Section {
                    VStack(spacing: 16) {
                        NavigationLink {
                            CreateAccountView()
                        } label: {
                            Text("Create account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                        
                        Button {
                            // navigate to login
                        } label: {
                            Text("Already have an account?")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }

                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            Text("or use")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
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
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
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
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.vertical, 8)
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
