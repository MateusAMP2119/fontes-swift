import SwiftUI

/// Main onboarding flow matching Flipboard design
/// Flow: Splash → Welcome → Interests → SignUp → (optional email auth) → Profile → Notifications → Loading → Complete
struct OnboardingFlowView: View {
    enum Step: Hashable {
        case interests
        case signUp
        case login
        case emailAuth(email: String)
        case profileSetup
        case notifications
        case loading
    }
    
    @State private var showSplash = true
    @State private var path: [Step] = []
    @State private var username: String = ""
    @State private var selectedInterests: [String] = []
    @Binding var isOnboardingCompleted: Bool
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .onAppear {
                        // Splash screen duration
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showSplash = false
                            }
                        }
                    }
            } else {
                NavigationStack(path: $path) {
                    WelcomeView(
                        onGetStarted: {
                            path.append(.interests)
                        },
                        onLogin: {
                            path.append(.login)
                        }
                    )
                    .navigationBarHidden(true)
                    .navigationDestination(for: Step.self) { step in
                        destinationView(for: step)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for step: Step) -> some View {
        switch step {
        case .interests:
            InterestsView(
                onContinue: {
                    path.append(.signUp)
                },
                onBack: {
                    path.removeLast()
                },
                onLogin: {
                    path.append(.login)
                }
            )
            
        case .signUp:
            SignUpView(
                onDismiss: {
                    path.removeLast()
                },
                onLogin: {
                    path.append(.login)
                },
                onEmailContinue: { email in
                    path.append(.emailAuth(email: email))
                },
                onSkip: {
                    // Skip to profile setup without account
                    path.append(.profileSetup)
                },
                username: username
            )
            
        case .login:
            LoginView(
                onDismiss: {
                    path.removeLast()
                },
                onLoginSuccess: {
                    withAnimation {
                        isOnboardingCompleted = true
                    }
                },
                onEmailLogin: { email in
                    path.append(.emailAuth(email: email))
                },
                onCreateAccount: {
                    if !path.contains(.signUp) {
                        path.append(.signUp)
                    } else {
                        path.removeLast()
                    }
                }
            )
            
        case .emailAuth(let email):
            EmailAuthView(
                onDismiss: {
                    path.removeLast()
                },
                onLogin: {
                    // After successful auth, go to profile setup
                    path.append(.profileSetup)
                },
                username: email
            )
            
        case .profileSetup:
            ProfileSetupView(
                onDone: {
                    path.append(.notifications)
                },
                username: $username
            )
            
        case .notifications:
            NotificationPermissionView(
                selectedInterests: selectedInterests,
                onAllow: {
                    path.append(.loading)
                },
                onSkip: {
                    path.append(.loading)
                }
            )
            
        case .loading:
            PersonalizationLoadingView(
                onComplete: {
                    withAnimation {
                        isOnboardingCompleted = true
                    }
                }
            )
        }
    }
}

#Preview {
    OnboardingFlowView(isOnboardingCompleted: .constant(false))
}
