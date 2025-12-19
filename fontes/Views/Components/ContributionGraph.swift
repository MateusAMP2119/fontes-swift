import SwiftUI

struct ContributionGraph: View {
    let days = 30 // Last 30 days
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7) // 7 days a week
    
    // Mock data: random intensity 0.0 to 1.0
    let data: [Double] = (0..<30).map { _ in Double.random(in: 0...1) }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Activity")
                .font(.headline)
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(0..<days, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.green.opacity(data[index]))
                        .frame(height: 20)
                }
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    ContributionGraph()
}
