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
                    .frame(width: 240)
                    .padding(.bottom, 10)
                    .offset(x: -20)
                
                Text("ENCONTRA TODAS AS HISTÓRIAS QUE \(Text("IMPORTAM").underline(true, color: Color.baseRed))")
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
