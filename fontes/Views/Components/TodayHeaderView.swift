import SwiftUI

struct TodayHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Row 1: Logo and "News"
            HStack(alignment: .center, spacing: 2,) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 28, weight: .heavy))
                    .offset(y: -1)
                
                Text("News")
                    .font(.system(size: 34, weight: .heavy))
                    .kerning(-1.4)
            }
            .foregroundStyle(.primary)
            
            // Row 2: The Date
            Text("December 17")
                .font(.system(size: 34, weight: .heavy, design: .default))
                .foregroundStyle(Color.gray)
                .kerning(-1.4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .offset(y: -14)
    }
}

#Preview {
    TodayHeaderView()
}
