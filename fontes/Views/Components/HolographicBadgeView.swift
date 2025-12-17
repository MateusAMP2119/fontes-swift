import SwiftUI
import CoreMotion

struct HolographicBadgeView: View {
    let badge: Badge
    var namespace: Namespace.ID
    var onDismiss: () -> Void
    
    // Gesture State
    @State private var rotation: CGSize = .zero
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.9)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 40) {
                // The Card
                ZStack {
                    // 1. Base Card
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(uiColor: .systemGray6),
                                    Color.white
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    // 2. Content
                    VStack(spacing: 20) {
                        Circle()
                            .fill(badge.color.opacity(0.2))
                            .frame(width: 120, height: 120)
                            .overlay {
                                Image(systemName: badge.icon)
                                    .font(.system(size: 60))
                                    .foregroundStyle(badge.color)
                            }
                        
                        VStack(spacing: 8) {
                            Text(badge.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                            
                            Text(badge.description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                                .padding(.horizontal)
                        }
                    }
                    .padding()
                    
                    // 3. Holographic Overlay
                    if badge.isEarned {
                        HolographicOverlay(rotation: rotation)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    // 4. Border
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.white.opacity(0.5), .clear, .white.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                }
                .frame(width: 300, height: 450)
                .matchedGeometryEffect(id: badge.id, in: namespace)
                .rotation3DEffect(
                    .degrees(Double(rotation.width / 10)),
                    axis: (x: 0, y: 1, z: 0)
                )
                .rotation3DEffect(
                    .degrees(Double(-rotation.height / 10)),
                    axis: (x: 1, y: 0, z: 0)
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.interactiveSpring) {
                                rotation = value.translation
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.spring) {
                                rotation = .zero
                            }
                        }
                )
                
                // Close Button
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

struct HolographicOverlay: View {
    var rotation: CGSize
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Iridescent Shine
                LinearGradient(
                    colors: [
                        .clear,
                        .blue.opacity(0.3),
                        .purple.opacity(0.3),
                        .pink.opacity(0.3),
                        .yellow.opacity(0.3),
                        .clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blendMode(.overlay)
                .offset(x: -rotation.width, y: -rotation.height)
                .scaleEffect(1.5)
                
                // Specular Highlight (Glare)
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.4),
                        .clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blendMode(.screen)
                .offset(x: rotation.width * 0.5, y: rotation.height * 0.5)
                .mask(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .white, .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .rotationEffect(.degrees(45))
                        .offset(x: -geo.size.width + rotation.width, y: 0)
                )
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    HolographicBadgeView(
        badge: Badge(name: "Preview Badge", icon: "star.fill", color: .yellow, isEarned: true, description: "You earned this by being awesome!"),
        namespace: namespace,
        onDismiss: {}
    )
}
