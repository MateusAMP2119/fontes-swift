import SwiftUI

// MARK: - Flipboard-inspired Design Constants

/// Primary brand color - Flipboard red
extension Color {
    static let flipboardRed = Color(red: 225/255, green: 40/255, blue: 40/255)
    static let charcoalDark = Color(red: 30/255, green: 30/255, blue: 32/255)
}

// MARK: - Typography Styles

struct OnboardingTitleStyle: ViewModifier {
    var size: CGFloat = 32
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .black))
            .textCase(.uppercase)
            .tracking(0.5)
    }
}

struct OnboardingSubtitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.gray)
    }
}

extension View {
    func onboardingTitle(size: CGFloat = 32) -> some View {
        modifier(OnboardingTitleStyle(size: size))
    }
    
    func onboardingSubtitle() -> some View {
        modifier(OnboardingSubtitleStyle())
    }
}

// MARK: - Button Styles

struct FlipboardPrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isEnabled ? Color.flipboardRed : Color.gray)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct FlipboardSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct FlipboardTextButtonStyle: ButtonStyle {
    var color: Color = .flipboardRed
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(color)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

// MARK: - Header Component

struct OnboardingHeader: View {
    var showSkip: Bool = false
    var showLogin: Bool = false
    var onSkip: (() -> Void)? = nil
    var onLogin: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 28)
            
            Spacer()
            
            if showLogin {
                Button(action: { onLogin?() }) {
                    Text("Entrar")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.flipboardRed)
                }
            }
            
            if showSkip {
                Button(action: { onSkip?() }) {
                    Text("Ignorar")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
}

// MARK: - Progress Bar

struct OnboardingProgressBar: View {
    var progress: CGFloat // 0.0 to 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 3)
                
                Rectangle()
                    .fill(Color.flipboardRed)
                    .frame(width: geometry.size.width * progress, height: 3)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 3)
    }
}

// MARK: - Text Field Styles

struct FlipboardTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 17))
                    .focused($isFocused)
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 17))
                    .focused($isFocused)
            }
            
            Rectangle()
                .fill(isFocused ? Color.flipboardRed : Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.top, 12)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

// MARK: - Topic Tag (Pill Style)

struct FlipboardTopicTag: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("#\(text)")
                .font(.system(size: 16, weight: .bold))
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.flipboardRed : Color(UIColor.systemGray6))
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Back Button

struct FlipboardBackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 48, height: 48)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
        }
    }
}

// MARK: - Continue Button

struct FlipboardContinueButton: View {
    var text: String = "Continuar"
    var isEnabled: Bool = true
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isEnabled ? Color.flipboardRed : Color.gray)
                )
        }
        .disabled(!isEnabled)
    }
}

// MARK: - Keyboard Toolbar

struct FlipboardKeyboardToolbar: View {
    var showBack: Bool = true
    var showNext: Bool = true
    var backEnabled: Bool = true
    var nextEnabled: Bool = true
    var nextText: String = "Seguinte"
    var onBack: (() -> Void)? = nil
    var onNext: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            if showBack {
                Button(action: { onBack?() }) {
                    Text("Voltar")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(backEnabled ? .white : .gray)
                }
                .disabled(!backEnabled)
            }
            
            Spacer()
            
            if showNext {
                Button(action: { onNext?() }) {
                    Text(nextText)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(nextEnabled ? Color.flipboardRed : Color.gray)
                        )
                }
                .disabled(!nextEnabled)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(UIColor.darkGray))
    }
}
