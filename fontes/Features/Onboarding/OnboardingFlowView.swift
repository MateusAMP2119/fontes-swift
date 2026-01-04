import SwiftUI

struct OnboardingFlowView: View {
    @State private var showSplash = true
    @Binding var isOnboardingCompleted: Bool
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .onAppear {
                        // Simulate loading or wait for a bit
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSplash = false
                            }
                        }
                    }
            } else {
                WelcomeView(onGetStarted: {
                    // Mark onboarding as completed
                    withAnimation {
                        isOnboardingCompleted = true
                    }
                })
            }
        }
    }
}

#Preview {
    OnboardingFlowView(isOnboardingCompleted: .constant(false))
}
