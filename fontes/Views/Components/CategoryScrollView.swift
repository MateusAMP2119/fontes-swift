import SwiftUI

struct CategoryScrollView: View {
    let categories = ["Sports", "Puzzles", "Politics", "Business", "Tech", "Science"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    HStack(spacing: 6) {
                        // Icons could be mapped, using generic for now
                        Image(systemName: iconForCategory(category))
                            .foregroundStyle(.gray)
                        Text(category)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
        }
    }
    
    func iconForCategory(_ category: String) -> String {
        switch category {
        case "Sports": return "sportscourt.fill"
        case "Puzzles": return "puzzlepiece.fill"
        case "Politics": return "building.columns.fill"
        case "Business": return "briefcase.fill"
        default: return "newspaper.fill"
        }
    }
}

#Preview {
    CategoryScrollView()
}
