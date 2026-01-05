import SwiftUI

struct OnboardingFlowView: View {
    enum Step: Hashable {
        case interests
        case shareInterests
        case signUp
        case login
        case emailAuth(email: String)
    }
    
    @State private var showSplash = true
    @State private var path: [Step] = []
    @State private var showProfileSheet = false
    @State private var username: String = ""
    @Binding var isOnboardingCompleted: Bool
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .onAppear {
                        // Simulate loading or wait for a bit
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showSplash = false
                            }
                        }
                    }
            } else {
                NavigationStack(path: $path) {
                    WelcomeView(onGetStarted: {
                        path.append(Step.interests)
                    }, onLogin: {
                        path.append(Step.login)
                    })
                    .navigationBarHidden(true)
                    .navigationDestination(for: Step.self) { step in
                        switch step {
                        case .interests:
                            InterestsView(onContinue: {
                                showProfileSheet = true
                            }, onBack: {
                                path.removeLast()
                            }, onLogin: {
                                path.append(.login)
                            })
                        case .shareInterests:
                            ShareInterestsView(onNext: {
                                path.append(.signUp)
                            }, onBack: {
                                path.removeLast()
                            })
                        case .signUp:
                            SignUpView(onDismiss: {
                                path.removeLast()
                            }, onLogin: {
                                if path.contains(.login) {
                                    path.removeLast()
                                } else {
                                    path.append(.login)
                                }
                            }, onEmailContinue: { email in
                                path.append(.emailAuth(email: email))
                            }, username: username)
                        case .login:
                            LoginView(onDismiss: {
                                path.removeLast()
                            }, onLoginSuccess: {
                                withAnimation {
                                    isOnboardingCompleted = true
                                }
                            }, onEmailLogin: { email in
                                path.append(.emailAuth(email: email))
                            }, onCreateAccount: {
                                if !path.contains(.signUp) {
                                    path.append(.signUp)
                                } else {
                                    // If we came from SignUp, pop back to it
                                    path.removeLast()
                                }
                            })
                        case .emailAuth(let email):
                            EmailAuthView(onDismiss: {
                                path.removeLast()
                            }, onLogin: {
                                withAnimation {
                                    isOnboardingCompleted = true
                                }
                            }, username: email)
                        }
                    }
                }
                .sheet(isPresented: $showProfileSheet) {
                    ProfileSetupView(onDone: {
                        showProfileSheet = false
                        // Small delay to allow sheet to dismiss before pushing next view
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            path.append(.shareInterests)
                        }
                    }, username: $username)
                    .presentationDetents([.fraction(0.94)])
                    .presentationDragIndicator(.visible)
                }
            }
        }
    }
}

#Preview {
    OnboardingFlowView(isOnboardingCompleted: .constant(false))
}
