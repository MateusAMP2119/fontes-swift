import SwiftUI

/// Interests selection screen matching Flipboard design (Screenshots 2-5, 9-11)
/// - Header with logo + red "Entrar" button
/// - Bold uppercase title "O QUE TE INTERESSA?"
/// - Gray subtitle explaining purpose
/// - Pill/chip tags with #hashtags, selected = red with white text
/// - Continue button activates (red) with 3+ selections
struct InterestsView: View {
    var onContinue: () -> Void
    var onBack: () -> Void
    var onLogin: () -> Void
    
    @State private var selectedTopics: Set<String> = []
    
    // Topics matching Flipboard style with hashtag prefix
    let topics = [
        "NOTÍCIAS", "TECNOLOGIA", "DESPORTO", "POLÍTICA",
        "NEGÓCIOS", "FAMOSOS", "ECONOMIA", "RECEITAS",
        "CIÊNCIA", "DESIGN", "FUTEBOL", "CLIMA",
        "FOTOGRAFIA", "PROGRAMAÇÃO", "VIAGENS", "SAÚDE",
        "MODA", "BELEZA", "MÚSICA", "CINEMA",
        "JOGOS", "CULTURA", "EDUCAÇÃO", "AMBIENTE"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with logo and Login button
            HStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                
                Spacer()
                
                Button(action: onLogin) {
                    Text("Entrar")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.baseRed)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            
            // Title Section
            VStack(alignment: .leading, spacing: 8) {
                Text("O QUE TE INTERESSA?")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.primary)
                
                Text("Segue os tópicos para influenciar as histórias que vês")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 24)
            
            // Topics Grid with Flow Layout
            ScrollView(showsIndicators: false) {
                InterestsFlowLayout(spacing: 10) {
                    ForEach(topics, id: \.self) { topic in
                        TopicTag(
                            text: "#\(topic)",
                            isSelected: selectedTopics.contains(topic)
                        ) {
                            toggleTopic(topic)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 120) // Space for bottom bar
            }
            
            Spacer()
            
            // Bottom Navigation
            VStack(spacing: 16) {
                // Terms text
                Text("Ao continuar, aceitas os Termos de Uso e a Política de Privacidade.")
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Back + Continue buttons
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 48, height: 48)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text(canContinue ? "Continuar" : buttonText)
                                .font(.system(size: 17, weight: .bold))
                            if canContinue {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 15, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(canContinue ? Color.baseRed : Color.gray)
                        )
                    }
                    .disabled(!canContinue)
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 32)
            .background(
                Color.white
                    .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
            )
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    var canContinue: Bool {
        selectedTopics.count >= 3
    }
    
    var buttonText: String {
        if canContinue {
            return "Continuar"
        } else {
            let remaining = 3 - selectedTopics.count
            return "Escolhe mais \(remaining) para continuar"
        }
    }
    
    func toggleTopic(_ topic: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if selectedTopics.contains(topic) {
                selectedTopics.remove(topic)
            } else {
                selectedTopics.insert(topic)
            }
        }
    }
}

/// Topic tag pill matching Flipboard design
/// - Rectangular with slight corner radius
/// - Gray background when unselected, red when selected
/// - Hashtag prefix on text
struct TopicTag: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 15, weight: .bold))
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.baseRed : Color(UIColor.systemGray6))
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Flow Layout for tags
struct InterestsFlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = flow(proposal: proposal, subviews: subviews, perform: false)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        _ = flow(proposal: proposal, subviews: subviews, perform: true, in: bounds)
    }

    private func flow(proposal: ProposedViewSize, subviews: Subviews, perform: Bool, in bounds: CGRect = .zero) -> (size: CGSize, unused: Bool) {
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        let maxWidth = proposal.width ?? .infinity

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > maxWidth {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            
            if perform {
                subview.place(at: CGPoint(x: bounds.minX + currentX, y: bounds.minY + currentY), proposal: .unspecified)
            }
            
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }
        
        return (CGSize(width: maxWidth, height: currentY + lineHeight), false)
    }
}

#Preview {
    InterestsView(onContinue: {}, onBack: {}, onLogin: {})
}
