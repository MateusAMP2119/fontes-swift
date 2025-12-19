import SwiftUI

struct TodayHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: -5) {
            // Row 1: "News"
            Text("Today")
                .font(.system(size: 34, weight: .heavy))
                .kerning(-1.4)
                .foregroundStyle(.primary)
            
            // Row 2: The Date
            Text("December 17")
                .font(.system(size: 34, weight: .heavy, design: .default))
                .foregroundStyle(Color.gray)
                .kerning(-1.4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .offset(y: -16)
    }
}

#Preview {
    TodayHeaderView()
}
