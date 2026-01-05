import SwiftUI

struct LoginView: View {
    var onDismiss: () -> Void
    var onLoginSuccess: () -> Void
    var onEmailLogin: () -> Void
    var onCreateAccount: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Back button
            HStack {
                Button(action: onDismiss) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                Spacer()
            }
            .padding()
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("WELCOME BACK")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.black)
                
                Text("Please log in to continue")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            
            VStack(spacing: 16) {
                Text("Previously used")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.6))
                
                // Log in with Email
                Button(action: onEmailLogin) {
                    Text("Log in with Email")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.baseRed)
                        .cornerRadius(4)
                }
                
                // Log in with other account
                Button(action: {}) {
                    Text("Log in with other account")
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                // Get login link
                Button(action: {}) {
                    Text("Get login link")
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                // Create new account
                Button(action: onCreateAccount) {
                    Text("Create new account")
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Text("By continuing, you accept the Terms of Use and Privacy Policy.")
                .font(.caption2)
                .foregroundColor(.gray.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginView(onDismiss: {}, onLoginSuccess: {}, onEmailLogin: {}, onCreateAccount: {})
}
