import SwiftUI

struct InterestsView: View {
    var onContinue: () -> Void
    var onBack: () -> Void
    var onLogin: () -> Void
    
    @State private var selectedTopics: Set<String> = []
    
    // Using the topics from the screenshot, translated to Portuguese where appropriate
    // or keeping them generic.
    let topics = [
        "NOTÍCIAS", "TECNOLOGIA", "DESPORTO", "POLÍTICA",
        "NEGÓCIOS", "FAMOSOS", "ECONOMIA", "RECEITAS",
        "CIÊNCIA", "DESIGN", "FUTEBOL", "CLIMA",
        "FOTOGRAFIA", "PROGRAMAÇÃO", "VIAGENS", "SAÚDE",
        "MODA", "BELEZA"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top Bar
            HStack {
                Image("headerLight")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                
                Spacer()
                
                Button(action: onLogin) {
                    Text("Entrar")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .glassEffect(.regular.tint(Color.baseRed), in: .rect(cornerRadius: 16.0))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("O QUE TE INTERESSA?")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.primary)
                
                Text("Segue os tópicos para influenciar as histórias que vês")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 24)
            
            // Topics Grid
            ScrollView {
                InterestsFlowLayout(spacing: 10) {
                    ForEach(topics, id: \.self) { topic in
                        TopicTag(
                            text: topic,
                            isSelected: selectedTopics.contains(topic)
                        ) {
                            toggleTopic(topic)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            
            Spacer()
            
            // Footer
            VStack {
                Text("Ao continuar, aceitas os Termos de Uso e a Política de Privacidade.")
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 16)
                
                // Bottom Navigation
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: onContinue) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(canContinue ? Color.baseRed : Color.gray)
                            .clipShape(Circle())
                    }
                    .disabled(!canContinue)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
            .background(Color.white) // Ensure background covers content behind
        }
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

struct TopicTag: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 16, weight: .bold)) // Condensed-like font
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.baseRed : Color(UIColor.systemGray6))
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Simple FlowLayout implementation
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
