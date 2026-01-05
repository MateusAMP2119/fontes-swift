import SwiftUI

/// Sign Up screen matching Flipboard design (Screenshot 6)
/// - Header with logo + "Ignorar" (Skip) button top right
/// - Bold uppercase title "CRIA UMA CONTA"
/// - Gray subtitle
/// - Social login buttons (Apple, Google, Facebook, Twitter) with icons
/// - Red "Continuar com Email" primary CTA
/// - "Já tens conta? Entrar." link at bottom
struct SignUpView: View {
    var onDismiss: () -> Void
    var onLogin: () -> Void
    var onEmailContinue: (String) -> Void
    var onSkip: (() -> Void)? = nil
    var username: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with logo and Skip button
            HStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                
                Spacer()
                
                if let onSkip = onSkip {
                    Button(action: onSkip) {
                        Text("Ignorar")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            
            Spacer()
            
            // Main Content
            VStack(spacing: 32) {
                // Title Section
                VStack(spacing: 8) {
                    Text("CRIA UMA CONTA")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.black)
                    
                    Text("Guarda os teus interesses e preferências")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Social Buttons Stack
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
                    
                    // Facebook Button
                    Button(action: {}) {
                        HStack(spacing: 12) {
                            Image(systemName: "f.square.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 24/255, green: 119/255, blue: 242/255))
                            Text("Continuar com Facebook")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    // X (Twitter) Button
                    Button(action: {}) {
                        HStack(spacing: 12) {
                            Text("𝕏")
                                .font(.system(size: 18, weight: .bold))
                            Text("Continuar com X")
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
                
                // Email CTA - Red primary button
                Button(action: { onEmailContinue("") }) {
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 18))
                        Text("Continuar com Email")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.baseRed)
                    )
                }
                .padding(.horizontal, 24)
                
                // Login Link
                HStack(spacing: 4) {
                    Text("Já tens conta?")
                        .foregroundColor(.gray)
                    Button(action: onLogin) {
                        Text("Entrar.")
                            .fontWeight(.bold)
                            .foregroundColor(.baseRed)
                    }
                }
                .font(.subheadline)
            }
            
            Spacer()
            
            // Terms at bottom
            Text("Ao continuar, aceitas os Termos de Uso e a Política de Privacidade.")
                .font(.caption2)
                .foregroundColor(.gray.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 32)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignUpView(onDismiss: {}, onLogin: {}, onEmailContinue: { _ in }, onSkip: {}, username: "Mateus")
}
