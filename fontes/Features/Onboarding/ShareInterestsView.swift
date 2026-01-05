import SwiftUI

struct ShareInterestsView: View {
    var onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Mockup Illustration
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 255/255, green: 107/255, blue: 107/255), Color(red: 255/255, green: 204/255, blue: 92/255)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 320)
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                
                VStack(alignment: .leading) {
                    HStack {
                        Circle()
                            .fill(.white.opacity(0.3))
                            .frame(width: 48, height: 48)
                        Spacer()
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Circle().fill(.white.opacity(0.3)))
                    }
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white.opacity(0.4))
                        .frame(width: 120, height: 16)
                        .padding(.bottom, 8)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(height: 24)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 200, height: 24)
                }
                .padding(32)
                .frame(height: 320)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
            
            // Text Content
            VStack(spacing: 16) {
                Text("CRIA O TEU ALGORITMO")
                    .font(.system(size: 28, weight: .black))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                Text("Edita as tuas preferências e cria, edita e partilha com amigos o teu próprio algoritmo de recomendações.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 32)
                    .lineSpacing(4)
            }
            
            Spacer()
            
            // Continue Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: onNext) {
                        Text("Continuar")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .padding(.horizontal, 32)
                    .glassEffect(.regular.tint(Color.baseRed).interactive())
                    Spacer()
                }
                .padding(.bottom, 16)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    ShareInterestsView(onNext: {})
}
