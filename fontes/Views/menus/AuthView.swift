import SwiftUI

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
    
    // Focus State
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    init(initialMode: AuthMode = .login) {
        _mode = State(initialValue: initialMode)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text(headerTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
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
            return "Enter your email"
        } else {
            return mode == .login ? "Welcome back" : "Create account"
        }
    }
    
    var emailStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                TextField("name@example.com", text: $email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .focused($isEmailFocused)
                    .submitLabel(.continue)
                    .onSubmit {
                        validateAndContinue()
                    }
                
                Button {
                    validateAndContinue()
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(email.isEmpty ? Color.gray : Color.black)
                        .cornerRadius(12)
                }
                .disabled(email.isEmpty)
            }
            .padding()
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(20)
            
            HStack {
                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                Text("or").font(.caption).foregroundColor(.gray)
                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
            }
            
            VStack(spacing: 12) {
                socialLoginButtons
            }
            .padding()
            .background(colorScheme == .dark ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemBackground))
            .cornerRadius(20)
        }
    }
    
    var passwordStepView: some View {
        VStack(spacing: 24) {
            if mode == .signup {
                TextField("Username", text: $username)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
            
            SecureField("Password", text: $password)
                .textContentType(mode == .signup ? .newPassword : .password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .focused($isPasswordFocused)
                .submitLabel(mode == .login ? .go : .next)
                .onSubmit {
                    if mode == .login {
                        handleAuthAction()
                    }
                }
            
            if mode == .signup {
                SecureField("Confirm Password", text: $confirmPassword)
                    .textContentType(.newPassword)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .submitLabel(.go)
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
        if !email.isEmpty {
            withAnimation {
                step = .password
                isPasswordFocused = true
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
}

#Preview {
    NavigationView {
        AuthView()
            .environmentObject(UserManager())
    }
}
