import SwiftUI

struct ActionsPopupView: View {
    struct QuickAction: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let systemImage: String
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
                action: onSaveForLater
            ),
            QuickAction(
                title: "Start focus",
                subtitle: "25 min reading",
                systemImage: "hourglass",
                action: onStartFocusSession
            ),
            QuickAction(
                title: "New folder",
                subtitle: "Organize your saves",
                systemImage: "folder.badge.plus",
                action: onAddFolder
            ),
            QuickAction(
                title: "Share",
                subtitle: "Send to a friend",
                systemImage: "square.and.arrow.up",
                action: onShareLink
            )
        ]
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quick actions")
                        .font(.title3.weight(.semibold))
                    Text("Do things fast without leaving the page.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(quickActions) { item in
                        Button {
                            trigger(item.action)
                        } label: {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: item.systemImage)
                                    .font(.title3.weight(.semibold))
                                    .frame(width: 32, height: 32)
                                    .background(Color.gray.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.primary)
                                    Text(item.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                }
                
                Spacer(minLength: 0)
            }
            .padding(20)
            .presentationDragIndicator(.visible)
            .background(Color(.systemBackground))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func trigger(_ action: @escaping () -> Void) {
        action()
        dismiss()
    }
}

#Preview {
    ActionsPopupView()
}
