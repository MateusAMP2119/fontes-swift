import SwiftUI

/// Loading/Personalization screen matching Flipboard design (Screenshots 20-21)
/// - White background
/// - "AGUARDA ENQUANTO PERSONALIZAMOS A TUA EXPERIÊNCIA..." text
/// - Transitions to red "Sucesso!" banner
/// - Then shows "PARA TI" appearing
struct PersonalizationLoadingView: View {
    var onComplete: () -> Void
    
    @State private var showSuccess = false
    @State private var showForYou = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            if showForYou {
                // Final "FOR YOU" state
                VStack {
                    Text("PARA TI")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.black)
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }
            } else if showSuccess {
                // Success banner state
                VStack(spacing: 24) {
                    Text("Sucesso!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.baseRed)
                        )
                }
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
            } else {
                // Loading state
                VStack(spacing: 32) {
                    // Loading indicator
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.baseRed)
                    
                    Text("AGUARDA ENQUANTO\nPERSONALIZAMOS A TUA\nEXPERIÊNCIA...")
                        .font(.system(size: 24, weight: .black))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startLoadingSequence()
        }
    }
    
    private func startLoadingSequence() {
        // Show loading for 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showSuccess = true
            }
            
            // Show success for 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSuccess = false
                    showForYou = true
                }
                
                // Complete after showing "FOR YOU"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    onComplete()
                }
            }
        }
    }
}

#Preview {
    PersonalizationLoadingView(onComplete: {})
}
