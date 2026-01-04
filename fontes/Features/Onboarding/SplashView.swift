import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 20) {                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
            }
        }
    }
}

#Preview {
    SplashView()
}
