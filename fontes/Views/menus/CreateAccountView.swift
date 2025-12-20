
import SwiftUI

struct CreateAccountView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var navigationSelection: String?
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    init(navigationSelection: Binding<String?> = .constant(nil)) {
        self._navigationSelection = navigationSelection
    }
    
    var body: some View {
        Form {
            Section {
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
                    Button {
                        // TODO: Implement create account logic
                    } label: {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
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
    }
}

#Preview {
    CreateAccountView()
}
