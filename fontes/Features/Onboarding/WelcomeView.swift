import SwiftUI

extension Color {
    static let baseRed = Color(red: 250/255, green: 45/255, blue: 72/255)
}

struct WelcomeView: View {
    var onGetStarted: () -> Void
    
    private let backgroundColor = Color.white
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
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
                
                HStack {
                    Spacer()
                    Button(action: onGetStarted) {
                        Text("Começar")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .padding(.horizontal, 32)
                    .glassEffect(.regular.tint(Color.baseRed).interactive())
                    Spacer()
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    WelcomeView(onGetStarted: {})
}
