import SwiftUI

struct OnboardingFlowView: View {
    enum Step: Hashable {
        case interests
        case shareInterests
        case signUp
    }
    
    @State private var showSplash = true
    @State private var path: [Step] = []
    @State private var showProfileSheet = false
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
                    })
                    .navigationBarHidden(true)
                    .navigationDestination(for: Step.self) { step in
                        switch step {
                        case .interests:
                            InterestsView(onContinue: {
                                showProfileSheet = true
                            }, onLogin: {
                                path.append(.signUp)
                            })
                        case .shareInterests:
                            ShareInterestsView(onNext: {
                                path.append(.signUp)
                            })
                        case .signUp:
                            SignUpView(onDismiss: {
                                if path.contains(.shareInterests) {
                                    withAnimation {
                                        isOnboardingCompleted = true
                                    }
                                } else {
                                    path.removeLast()
                                }
                            }, onLogin: {
                                withAnimation {
                                    isOnboardingCompleted = true
                                }
                            })
                        }
                    }
                }
                .sheet(isPresented: $showProfileSheet) {
                    ProfileSetupView(onDone: {
                        showProfileSheet = false
                        // Small delay to allow sheet to dismiss before pushing next view
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            path.append(Step.shareInterests)
                        }
                    })
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
