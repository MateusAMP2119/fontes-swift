import SwiftUI

struct SignUpView: View {
    var onDismiss: () -> Void
    var onLogin: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Skip button
            HStack {
                Spacer()
                Button(action: onDismiss) {
                    Text("Saltar por agora")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
            }
            .padding()
            
            Spacer()
            
            VStack(spacing: 24) {
                Text("REGISTA-TE PARA GUARDAR OS TEUS INTERESSES")
                    .font(.system(size: 28, weight: .black))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                
                // Email Button
                Button(action: {}) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Continuar com Email")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.baseRed)
                    .cornerRadius(4)
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
                HStack(spacing: 20) {
                    SocialButton(icon: "applelogo", color: .black)
                    SocialButton(text: "G", color: .blue) // Google placeholder
                    SocialButton(text: "f", color: Color(red: 0.23, green: 0.35, blue: 0.6)) // Facebook placeholder
                    SocialButton(text: "X", color: Color(red: 0.11, green: 0.63, blue: 0.95)) // Twitter/X placeholder
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
                
                // Terms
                Text("Ao continuar, aceitas os Termos de Uso e a Política de Privacidade.")
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
}

struct SocialButton: View {
    var icon: String?
    var text: String?
    var color: Color
    
    var body: some View {
        Button(action: {}) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 60, height: 60)
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                } else if let text = text {
                    Text(text)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    SignUpView(onDismiss: {}, onLogin: {})
}
