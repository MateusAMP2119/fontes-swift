import SwiftUI

/// Splash screen matching Flipboard design (Screenshot 0)
/// - Centered red logo on clean white background
/// - Minimal, focused branding moment
struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            // Centered logo - matches Flipboard's centered red logo
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
        }
    }
}

#Preview {
    SplashView()
}
