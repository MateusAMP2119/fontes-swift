import SwiftUI

struct AlgorithmExplanationView: View {
    var onContinue: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Image("headerLight")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(.baseRed)
                
                Text("O teu algoritmo")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Os teus interreses são usadas para criar uma página 'Para ti' predefinada. Em qualquer alutura, podes editá-la, criar novas páginas e partilhá-las a qualquer momento.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
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
                    HStack {
                        Text("Continuar")
                            .font(.headline)
                        Image(systemName: "arrow.right")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.baseRed)
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    AlgorithmExplanationView(onContinue: {}, onBack: {})
}
