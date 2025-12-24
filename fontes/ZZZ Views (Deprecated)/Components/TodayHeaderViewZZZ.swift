import SwiftUI

struct TodayHeaderViewZZZ: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Row 1: Icon and Title
            HStack(alignment: .center, spacing: 6) {
                Image(systemName: "newspaper.fill")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.blue)
                    .offset(y: -1)
                
                Text("Today")
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
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}

#Preview {
    TodayHeaderViewZZZ()
}
