import SwiftUI

struct LoginView: View {
    var onDismiss: () -> Void
    var onLoginSuccess: () -> Void
    var onEmailLogin: (String) -> Void
    var onCreateAccount: () -> Void
    
    @State private var email: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image("headerLight")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            
            Spacer()
            
            VStack(spacing: 24) {
                Text("Bem-vindo de volta")
                    .font(.system(size: 28, weight: .black))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                
                // Email Input
                TextField("Insere o teu email", text: $email)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                
                // Continue Button
                Button(action: { onEmailLogin(email) }) {
                    Text("Continuar")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .fill(Color.baseRed)
                        )
                }
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
                VStack(spacing: 16) {
                    // Apple Button
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "applelogo")
                                .font(.system(size: 22))
                            Text("Continuar com Apple")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    // Google Button
                    Button(action: {}) {
                        HStack {
                            Image("Google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                            Text("Continuar com Google")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 24)
                }
                
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
                
                // Terms
                Text("Ao continuar, aceitas os Termos de Uso e a Política de Privacidade.")
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // Bottom Navigation
            HStack {
                Button(action: onDismiss) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: { onEmailLogin(email) }) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.baseRed)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView(onDismiss: {}, onLoginSuccess: {}, onEmailLogin: { _ in }, onCreateAccount: {})
}
