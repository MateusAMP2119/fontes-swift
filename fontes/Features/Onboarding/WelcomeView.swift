import SwiftUI

extension Color {
    static let baseRed = Color(red: 225/255, green: 40/255, blue: 40/255)
    static let cyanAccent = Color(red: 0/255, green: 210/255, blue: 211/255)
    static let welcomeDark = Color(red: 28/255, green: 28/255, blue: 30/255)
}

/// Welcome screen matching Flipboard design (Screenshot 1)
/// - Dark charcoal background (#1C1C1E)
/// - White bold uppercase text with cyan underline accent on key word
/// - White "Get started" button at bottom
struct WelcomeView: View {
    var onGetStarted: () -> Void
    var onLogin: () -> Void
    
    var body: some View {
        ZStack {
            Color.welcomeDark
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                // Main headline - matches Flipboard's bold uppercase style
                // with cyan underline on "IMPORTAM" (key word like "MATTER")
                VStack(alignment: .leading, spacing: 0) {
                    Text("ENCONTRA")
                        .font(.system(size: 42, weight: .black))
                        .foregroundColor(.white)
                    
                    Text("TODAS AS")
                        .font(.system(size: 42, weight: .black))
                        .foregroundColor(.white)
                    
                    Text("HISTÓRIAS")
                        .font(.system(size: 42, weight: .black))
                        .foregroundColor(.white)
                    
                    Text("QUE")
                        .font(.system(size: 42, weight: .black))
                        .foregroundColor(.white)
                    
                    // Key word with cyan underline (like "MATTER" in Flipboard)
                    Text("IMPORTAM")
                        .font(.system(size: 42, weight: .black))
                        .foregroundColor(.white)
                        .underline(true, color: .cyanAccent)
                }
                .lineSpacing(-4)
                
                Spacer()
                
                // Bottom section with "Get started" button
                VStack(spacing: 24) {
                    Button(action: onGetStarted) {
                        Text("Começar")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.welcomeDark)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                            )
                    }
                    
                    // Already have account - subtle gray text
                    Button(action: onLogin) {
                        Text("Já tenho uma conta")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 50)
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    WelcomeView(onGetStarted: {}, onLogin: {})
}
