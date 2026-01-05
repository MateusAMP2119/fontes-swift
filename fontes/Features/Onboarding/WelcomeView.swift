import SwiftUI

extension Color {
    static let baseRed = Color(red: 250/255, green: 45/255, blue: 72/255)
}

struct NewspaperCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 100)
            
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 24, height: 24)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 12)
                    .frame(maxWidth: .infinity)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                }
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 8)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 5)
        .frame(width: 260)
    }
}

struct WelcomeView: View {
    var onGetStarted: () -> Void
    var onLogin: () -> Void
    
    private let backgroundColor = Color.white
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            // Background decoration
            GeometryReader { geometry in
                ZStack {
                    // Top Right Card
                    NewspaperCard()
                        .rotationEffect(.degrees(12))
                        .offset(x: geometry.size.width - 80, y: 60)

                    // Top Left Card
                    NewspaperCard()
                        .rotationEffect(.degrees(-15))
                        .offset(x: -60, y: 120)
                    
                    // Middle Right Card (Original position roughly)
                    NewspaperCard()
                        .rotationEffect(.degrees(8))
                        .offset(x: geometry.size.width - 160, y: geometry.size.height * 0.55)
                    
                    // Bottom Left Card
                    NewspaperCard()
                        .rotationEffect(.degrees(-5))
                        .scaleEffect(0.9)
                        .offset(x: -40, y: geometry.size.height * 0.8)
                }
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                Image("headerLight")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220)
                    .offset(x: -10)
                
                Text("ENCONTRA \(Text("TODAS").underline(true, color: Color.baseRed)) AS HISTÓRIAS QUE IMPORTAM")
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                VStack(spacing: 24) {
                    Button(action: onGetStarted) {
                        HStack(spacing: 24){
                            Text("Começar")
                                .font(.headline)
                            Image(systemName: "arrow.right")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding(.leading, 48)
                        .padding(.trailing, 34)
                        .padding(.vertical, 16)
                    }
                    .glassEffect(.regular.tint(Color.baseRed).interactive())
                    
                    Button(action: onLogin) {
                        Text("Já tenho uma conta")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 50)
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    WelcomeView(onGetStarted: {}, onLogin: {})
}
