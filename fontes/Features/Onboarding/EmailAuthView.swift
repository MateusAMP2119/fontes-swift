import SwiftUI

struct EmailAuthView: View {
    var onDismiss: () -> Void
    var onLogin: () -> Void
    var username: String?
    
    @State private var emailOrUsername: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case password
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Spacer()
            }
            .padding()
            .frame(height: 44)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 24) {
                Text(titleText)
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.black)
                
                VStack(spacing: 20) {
                    TextField("Username or Email", text: $emailOrUsername)
                        .focused($focusedField, equals: .email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.bottom, 8)
                        .overlay(
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1),
                            alignment: .bottom
                        )
                    
                    SecureField("Password", text: $password)
                        .focused($focusedField, equals: .password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.bottom, 8)
                        .overlay(
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1),
                            alignment: .bottom
                        )
                }
                
                HStack {
                    Button("iCloud Keychain") { }
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button("Forgot your password?") { }
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Custom Keyboard Accessory / Bottom Bar
            VStack(spacing: 0) {
                Divider()
                HStack {
                    Button(action: onDismiss) {
                        Text("Back")
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                    }
                    
                    Spacer()
                    
                    Text("Passwords")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.leading, -40) // Center visually roughly
                    
                    Spacer()
                    
                    Button(action: onLogin) {
                        Text("Log in")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.baseRed)
                            .cornerRadius(4)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .background(Color.black)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            if let username = username, !username.isEmpty {
                // If we have a username from onboarding, maybe prefill it?
                // The requirement says "Instead of 'Login' ... it should says the username"
                // It doesn't explicitly say to prefill the field, but it makes sense if we are "logging in" as that user?
                // Actually, if it's SIGN UP flow, we are creating a password for that username.
                // But the view is "EmailAuthView" (Log In style).
                // Let's stick to the title change requirement.
            }
            focusedField = .email
        }
    }
    
    var titleText: String {
        if let username = username, !username.isEmpty {
            return username.uppercased()
        }
        return "LOG IN"
    }
}

#Preview {
    EmailAuthView(onDismiss: {}, onLogin: {}, username: nil)
}
