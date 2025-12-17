import SwiftUI

struct TodayHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 2) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 22, weight: .bold))
                Text("News")
                    .font(.system(size: 36, weight: .black))
                    .tracking(-1) // Tighten tracking for "News"
            }
            
            Text("December 16")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(Color(uiColor: .systemGray))
                .tracking(-0.5)
        }
        .padding(.horizontal)
    }
}

#Preview {
    TodayHeaderView()
}
