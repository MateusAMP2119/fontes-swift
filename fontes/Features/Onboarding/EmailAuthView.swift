import SwiftUI

/// Email/Password authentication screen matching Flipboard design (Screenshots 7-8)
/// - Username displayed as title in uppercase
/// - Username/email field with underline style
/// - Password field with underline style
/// - Keyboard toolbar with Back button and red "Entrar" button
/// - Helper links for iCloud Keychain and Forgot Password
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
            // Header with gray background
            HStack {
                Button(action: onDismiss) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Palavras-passe")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                
                Spacer()
                
                // Invisible placeholder for centering
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.clear)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(UIColor.systemGray6))
            
            // Main content
            VStack(alignment: .leading, spacing: 24) {
                // Title - username in uppercase if available
                Text(titleText)
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.black)
                    .padding(.top, 32)
                
                // Email/Username field with underline
                VStack(spacing: 0) {
                    TextField("Email ou nome de utilizador", text: $emailOrUsername)
                        .font(.system(size: 17))
                        .focused($focusedField, equals: .email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    Rectangle()
                        .fill(focusedField == .email ? Color.baseRed : Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .padding(.top, 12)
                }
                
                // Password field with underline
                VStack(spacing: 0) {
                    SecureField("Palavra-passe", text: $password)
                        .font(.system(size: 17))
                        .focused($focusedField, equals: .password)
                    
                    Rectangle()
                        .fill(focusedField == .password ? Color.baseRed : Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .padding(.top, 12)
                }
                
                // Helper links
                HStack {
                    Button("Porta-chaves iCloud") { }
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button("Esqueceste a palavra-passe?") { }
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Bottom Navigation
            VStack(spacing: 16) {
                // Back + Continue buttons
                HStack {
                    Button(action: onDismiss) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 48, height: 48)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: onLogin) {
                        HStack(spacing: 8) {
                            Text("Continuar")
                                .font(.system(size: 17, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(canLogin ? Color.baseRed : Color.gray)
                        )
                    }
                    .disabled(!canLogin)
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 32)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            if let username = username, !username.isEmpty {
                emailOrUsername = username
                focusedField = .password
            } else {
                focusedField = .email
            }
        }
    }
    
    var canLogin: Bool {
        !emailOrUsername.isEmpty && !password.isEmpty
    }
    
    var titleText: String {
        if let username = username, !username.isEmpty {
            return username.uppercased()
        }
        return "ENTRAR"
    }
}

#Preview {
    EmailAuthView(onDismiss: {}, onLogin: {}, username: "mateus@example.com")
}
