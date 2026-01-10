import SwiftUI

struct ActionsPopupView: View {
    struct QuickAction: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let systemImage: String
        let isBeta: Bool
        let action: () -> Void
    }
    
    var onMyFeed: () -> Void = {}
    var onFinder: () -> Void = {}
    var onCollaborative: () -> Void = {}
    
    @Environment(\.dismiss) private var dismiss
    
    private var quickActions: [QuickAction] {
        [
            QuickAction(
                title: "My feed",
                subtitle: "Create or edit a feed",
                systemImage: "newspaper.fill",
                isBeta: false,
                action: onMyFeed
            ),
            QuickAction(
                title: "Finder",
                subtitle: "Find a feed and add it to your library",
                systemImage: "magnifyingglass",
                isBeta: false,
                action: onFinder
            ),
            QuickAction(
                title: "Collaborative",
                subtitle: "Build a feed with friends",
                systemImage: "person.2.fill",
                isBeta: false,
                action: onCollaborative
            )
        ]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header pill
            Text("Feed Actions")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .glassEffect(.regular.tint(.clear).interactive())
                .padding(.bottom, 18)
                .padding(.top, 24)

            // Action rows
            VStack(spacing: 8) {
                ForEach(quickActions) { item in
                    Button {
                        trigger(item.action)
                    } label: {
                        HStack(spacing: 20) {
                            // Circular icon
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Image(systemName: item.systemImage)
                                        .font(.title)
                                        .foregroundColor(.primary)
                                )
                            
                            // Text content
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 8) {
                                    Text(item.title)
                                        .font(.title3.weight(.semibold))
                                        .foregroundColor(.primary)
                                    
                                    if item.isBeta {
                                        Text("Beta")
                                            .font(.caption2.weight(.semibold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(Color.green)
                                            .clipShape(Capsule())
                                    }
                                }
                                
                                Text(item.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .presentationDetents([.height(380)])
        .presentationDragIndicator(.hidden)
    }
    
    private func trigger(_ action: @escaping () -> Void) {
        action()
        dismiss()
    }
}

#Preview {
    Text("Background")
        .sheet(isPresented: .constant(true)) {
            ActionsPopupView()
        }
}
