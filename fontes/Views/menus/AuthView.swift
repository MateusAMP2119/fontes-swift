import SwiftUI
import UIKit

struct AuthView: View {
    enum AuthMode {
        case login
        case signup
    }
    
    enum AuthStep {
        case email
        case password
    }
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userManager: UserManager
    
    @State private var mode: AuthMode
    @State private var step: AuthStep = .email
    
    // Form Fields
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    
    // UI State
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var invalidEmailAttempts = 0
    @State private var showEmailError = false
    
    // Focus State
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    init(initialMode: AuthMode = .login) {
        _mode = State(initialValue: initialMode)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if UIImage(named: "fontes_byMarrco") != nil {
                Image("fontes_byMarrco")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .padding(.bottom, 8)
                    .accessibilityHidden(true)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.1))
                    VStack(spacing: 6) {
                        Image(systemName: "photo")
                            .foregroundColor(.secondary)
                        Text("Missing asset: fontes_byMarreco")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(height: 120)
                .padding(.top, 24)
                .padding(.bottom, 8)
                .onAppear {
                    print("AuthView: 'fontes_byMarreco' not found in main bundle. Check asset name and target membership.")
                }
            }
            
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text(headerTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                if step == .password {
                    HStack {
                        Text(email)
                            .foregroundColor(.secondary)
                        Button("Change") {
                            withAnimation {
                                step = .email
                                isEmailFocused = true
                            }
                        }
                        .font(.subheadline)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 30)
            
            ScrollView {
                VStack(spacing: 20) {
                    if step == .email {
                        emailStepView
                    } else {
                        passwordStepView
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(colorScheme == .dark ? Color(uiColor: .systemBackground) : Color(uiColor: .secondarySystemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), 
                  message: Text(errorMessage ?? "Unknown error"), 
                  dismissButton: .default(Text("OK")))
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: step)
        .animation(.default, value: mode)
        .onAppear {
            isEmailFocused = true
        }
    }
    
    private var headerTitle: String {
        if step == .email {
            return "Qual é o teu e-mail?"
        } else {
            return mode == .login ? "Feliz de te ver!" : "Cria uma conta"
        }
    }
    
    var emailStepView: some View {
            VStack(spacing: 16) {
                TextField("", text: $email)
                    .placeholder(when: email.isEmpty) {
                        Text("name@example.com")                    }
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(showEmailError ? Color.red : Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .focused($isEmailFocused)
                    .submitLabel(.continue)
                    .tint(.gray)
                    .onSubmit {
                        validateAndContinue()
                    }
                    .modifier(Shake(animatableData: CGFloat(invalidEmailAttempts)))
                    .onChange(of: email) { _ in
                        showEmailError = false
                    }
                
                if showEmailError {
                    Text("e-mail inválido")
                        .foregroundColor(.red)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 4)
                        .transition(.opacity)
                }
                
                Button {
                    validateAndContinue()
                } label: {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(12)
                    } else {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(12)
                    }
                }
                .disabled(isLoading)
            
            HStack {
                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                Text("or").font(.caption).foregroundColor(.gray)
                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
            }
                socialLoginButtons
            }
            .padding()
            .background(colorScheme == .dark ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemBackground))
            .cornerRadius(12)
    }
    
    var passwordStepView: some View {
        VStack(spacing: 24) {
            if mode == .signup {
                TextField("", text: $username)
                    .placeholder(when: username.isEmpty) {
                        Text("Username").foregroundColor(.gray)
                    }
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .tint(.black)
            }
            
            SecureField("", text: $password)
                .placeholder(when: password.isEmpty) {
                    Text("Password").foregroundColor(.gray)
                }
                .textContentType(mode == .signup ? .newPassword : .password)
                .padding()
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .focused($isPasswordFocused)
                .submitLabel(mode == .login ? .go : .next)
                .tint(.black)
                .onSubmit {
                    if mode == .login {
                        handleAuthAction()
                    }
                }
            
            if mode == .signup {
                SecureField("", text: $confirmPassword)
                    .placeholder(when: confirmPassword.isEmpty) {
                        Text("Confirm Password").foregroundColor(.gray)
                    }
                    .textContentType(.newPassword)
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .submitLabel(.go)
                    .tint(.black)
                    .onSubmit {
                        handleAuthAction()
                    }
            }
            
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                Button {
                    handleAuthAction()
                } label: {
                    Text(mode == .login ? "Login" : "Create Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
            }
            
            if mode == .signup {
                HStack {
                    Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                    Text("or").font(.caption).foregroundColor(.gray)
                    Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                }
                socialLoginButtons
            }
            
            Button {
                withAnimation {
                    mode = (mode == .login) ? .signup : .login
                }
            } label: {
                Text(mode == .login ? "New here? Create an account" : "Already have an account? Log in")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemBackground))
        .cornerRadius(12)
    }
    
    var socialLoginButtons: some View {
        VStack(spacing: 12) {
            Button {
                // Action for Google auth
            } label: {
                HStack {
                    Image("google_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text("Continue with Google")
                }
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }
            
            Button {
                // Action for Apple auth
            } label: {
                HStack {
                    Image(systemName: "apple.logo")
                    Text("Continue with Apple")
                }
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }
        }
    }
    
    private func validateAndContinue() {
        guard !email.isEmpty, isValidEmail(email) else {
            withAnimation {
                invalidEmailAttempts += 1
                showEmailError = true
            }
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let response: UserExistsData = try await NetworkClient.shared.get(
                    path: "/api/auth/users/exists",
                    queryItems: [URLQueryItem(name: "email", value: email)]
                )
                
                await MainActor.run {
                    withAnimation {
                        mode = response.exists ? .login : .signup
                        step = .password
                        isPasswordFocused = true
                        isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Could not verify email: \(error.localizedDescription)"
                    showError = true
                }
            }
        }
    }
    
    private func handleAuthAction() {
        if mode == .signup {
            guard password == confirmPassword else {
                errorMessage = "Passwords do not match"
                showError = true
                return
            }
        }
        
        Task {
            isLoading = true
            do {
                if mode == .login {
                    let request = LoginRequestModel(username: email, email: email, password: password)
                    try await userManager.login(request: request)
                } else {
                    let request = SignupRequestModel(username: username, password: password, email: email, role: "VIEWER")
                    try await userManager.register(request: request)
                }
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isLoading = false
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

private extension View {
    func placeholder<Content: View>(when shouldShow: Bool, alignment: Alignment = .leading, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    NavigationView {
        AuthView()
            .environmentObject(UserManager())
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * shakesPerUnit),
            y: 0))
    }
}

