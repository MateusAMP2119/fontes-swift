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
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Quick actions")
                            .font(.title3.weight(.semibold))
                        Text("Do things fast without leaving the page.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .listRowInsets(EdgeInsets())
                }
                
                Section {
                    ForEach(quickActions) { item in
                        Button {
                            trigger(item.action)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: item.systemImage)
                                    .font(.title3.weight(.semibold))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .font(.subheadline.weight(.semibold))
                                    Text(item.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .presentationDragIndicator(.visible)
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
