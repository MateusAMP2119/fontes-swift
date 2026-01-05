import SwiftUI
import UserNotifications

/// Notification permission screen matching Flipboard design (Screenshots 18-19)
/// - Bold uppercase title "QUERES ATUALIZAÇÕES SOBRE [interests] E MAIS?"
/// - Selected interests displayed in red text
/// - "E MAIS?" in black text
/// - Red "Sim, por favor" button
/// - Gray "Agora não" secondary option below
struct NotificationPermissionView: View {
    var selectedInterests: [String]
    var onAllow: () -> Void
    var onSkip: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Main Title with interests in red
            VStack(spacing: 16) {
                Text("QUERES")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.black)
                
                Text("ATUALIZAÇÕES")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.black)
                
                Text("SOBRE")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.black)
                
                // Interests in red (show up to 3)
                ForEach(displayedInterests, id: \.self) { interest in
                    Text(interest.uppercased() + ",")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.baseRed)
                }
                
                Text("E MAIS?")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.black)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Bottom Navigation
            VStack(spacing: 16) {
                // Back + Continue buttons
                HStack {
                    Button(action: onSkip) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 48, height: 48)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        requestNotificationPermission()
                    }) {
                        HStack(spacing: 8) {
                            Text("Continuar")
                                .font(.system(size: 17, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(Color.baseRed)
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                // Secondary option - Gray "Not now" text
                Button(action: onSkip) {
                    Text("Agora não")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 32)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    var displayedInterests: [String] {
        Array(selectedInterests.prefix(3))
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                onAllow()
            }
        }
    }
}

#Preview {
    NotificationPermissionView(
        selectedInterests: ["DESIGN", "FOTOGRAFIA", "TECNOLOGIA"],
        onAllow: {},
        onSkip: {}
    )
}
