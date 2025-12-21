
import SwiftUI

struct CreateAccountView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userManager: UserManager
    @Binding var navigationSelection: String?
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    
    init(navigationSelection: Binding<String?> = .constant(nil)) {
        self._navigationSelection = navigationSelection
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textContentType(.newPassword)
                
                SecureField("Verify Password", text: $confirmPassword)
                    .textContentType(.newPassword)
            } header: {
                Text("Account Details")
            }
            
            Section {
                VStack(spacing: 16) {
                    if isLoading {
                        ProgressView()
                            .padding()
                    } else {
                        Button {
                            guard password == confirmPassword else {
                                errorMessage = "Passwords do not match"
                                showError = true
                                return
                            }
                            
                            Task {
                                isLoading = true
                                do {
                                    let request = SignupRequestModel(username: username, password: password, email: email, role: "VIEWER")
                                    try await userManager.register(request: request)
                                    dismiss()
                                } catch {
                                    errorMessage = error.localizedDescription
                                    showError = true
                                }
                                isLoading = false
                            }
                        } label: {
                            Text("Create Account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                    }
                    Button {
                        withAnimation {
                            navigationSelection = "login"
                        }
                    } label: {
                        Text("Already have an account?")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .underline()
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
                        // Action for Google sign up
                    } label: {
                        HStack {
                            Image("google_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text("Continue with Google")
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
                        // Action for Apple sign up
                    } label: {
                        HStack {
                            Image(systemName: "apple.logo")
                            Text("Continue with Apple")
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
            }
        }
        .navigationTitle("Create Account")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showError) {
            Alert(title: Text("Registration Failed"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    CreateAccountView()
}
