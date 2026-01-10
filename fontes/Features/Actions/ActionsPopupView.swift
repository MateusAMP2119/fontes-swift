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
    
    var onSaveForLater: () -> Void = {}
    var onStartFocusSession: () -> Void = {}
    var onAddFolder: () -> Void = {}
    var onShareLink: () -> Void = {}
    
    @Environment(\.dismiss) private var dismiss
    
    private var quickActions: [QuickAction] {
        [
            QuickAction(
                title: "Save for later",
                subtitle: "Bookmark this page",
                systemImage: "bookmark.fill",
                isBeta: false,
                action: onSaveForLater
            ),
            QuickAction(
                title: "Start focus",
                subtitle: "25 min reading session",
                systemImage: "hourglass",
                isBeta: true,
                action: onStartFocusSession
            ),
            QuickAction(
                title: "New folder",
                subtitle: "Organize your saves",
                systemImage: "folder.badge.plus",
                isBeta: false,
                action: onAddFolder
            ),
            QuickAction(
                title: "Share",
                subtitle: "Send to a friend",
                systemImage: "square.and.arrow.up",
                isBeta: false,
                action: onShareLink
            )
        ]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Drag indicator
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 16)
            
            // Action rows
            VStack(spacing: 0) {
                ForEach(quickActions) { item in
                    Button {
                        trigger(item.action)
                    } label: {
                        HStack(spacing: 16) {
                            // Circular icon
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Image(systemName: item.systemImage)
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                )
                            
                            // Text content
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 8) {
                                    Text(item.title)
                                        .font(.body.weight(.semibold))
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
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .presentationDetents([.medium])
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
