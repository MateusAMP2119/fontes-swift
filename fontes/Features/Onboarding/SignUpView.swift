import SwiftUI

struct SignUpView: View {
    var onDismiss: () -> Void
    var onLogin: () -> Void
    var onEmailContinue: () -> Void
    
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
                Text("REGISTA-TE PARA GUARDAR OS TEUS INTERESSES")
                    .font(.system(size: 28, weight: .black))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                
                // Email Button
                Button(action: onEmailContinue) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Continuar com Email")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                }
                .padding()
                .padding(.horizontal, 32)
                .glassEffect(.regular.tint(Color.baseRed).interactive())
                
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
                            Text("Continuar com Apple")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.black)
                    }
                    .padding()
                    .padding(.horizontal, 32)
                    .glassEffect(.regular.tint(Color.gray.opacity(0.2)).interactive())
                    .overlay(
                        Capsule()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Google Button
                    Button(action: {}) {
                        HStack {
                            Text("G")
                                .font(.system(size: 20, weight: .bold))
                            Text("Continuar com Google")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.black)
                    }
                    .padding()
                    .padding(.horizontal, 32)
                    .glassEffect(.regular.tint(Color.gray.opacity(0.2)).interactive())
                    .overlay(
                        Capsule()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignUpView(onDismiss: {}, onLogin: {}, onEmailContinue: {})
}
