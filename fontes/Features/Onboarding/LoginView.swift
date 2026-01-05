import SwiftUI

/// Login screen matching Flipboard design (Screenshots 7-8)
/// - Header with gray background
/// - Bold uppercase title "ENTRAR"
/// - Email/username field with underline style
/// - Social login options
/// - Keyboard toolbar with Back/Next buttons
struct LoginView: View {
    var onDismiss: () -> Void
    var onLoginSuccess: () -> Void
    var onEmailLogin: (String) -> Void
    var onCreateAccount: () -> Void
    
    @State private var email: String = ""
    @FocusState private var isEmailFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with logo
            HStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color(UIColor.systemGray6))
            
            ScrollView {
                VStack(spacing: 32) {
                    // Title Section
                    VStack(spacing: 8) {
                        Text("ENTRAR")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(.black)
                        
                        Text("Bem-vindo de volta")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                    
                    // Email Input with underline style
                    VStack(spacing: 0) {
                        TextField("Email ou nome de utilizador", text: $email)
                            .font(.system(size: 17))
                            .focused($isEmailFocused)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        Rectangle()
                            .fill(isEmailFocused ? Color.baseRed : Color.gray.opacity(0.3))
                            .frame(height: 1)
                            .padding(.top, 12)
                    }
                    .padding(.horizontal, 24)
                    
                    // Continue Button
                    Button(action: { onEmailLogin(email) }) {
                        Text("Continuar")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(email.isEmpty ? Color.gray : Color.baseRed)
                            )
                    }
                    .disabled(email.isEmpty)
                    .padding(.horizontal, 24)
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                        Text("OU")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 24)
                    
                    // Social Buttons
                    VStack(spacing: 12) {
                        // Apple Button
                        Button(action: {}) {
                            HStack(spacing: 12) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 20))
                                Text("Continuar com Apple")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        // Google Button
                        Button(action: {}) {
                            HStack(spacing: 12) {
                                Image("Google")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("Continuar com Google")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Create Account Link
                    HStack(spacing: 4) {
                        Text("Ainda não tens conta?")
                            .foregroundColor(.gray)
                        Button(action: onCreateAccount) {
                            Text("Criar conta.")
                                .fontWeight(.bold)
                                .foregroundColor(.baseRed)
                        }
                    }
                    .font(.subheadline)
                    
                    Spacer(minLength: 40)
                }
            }
            
            // Bottom Navigation
            VStack(spacing: 16) {
                // Terms text
                Text("Ao continuar, aceitas os Termos de Uso e a Política de Privacidade.")
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
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
                    
                    Button(action: { onEmailLogin(email) }) {
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
                                .fill(email.isEmpty ? Color.gray : Color.baseRed)
                        )
                    }
                    .disabled(email.isEmpty)
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 32)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear {
            isEmailFocused = true
        }
    }
}

#Preview {
    LoginView(onDismiss: {}, onLoginSuccess: {}, onEmailLogin: { _ in }, onCreateAccount: {})
}
