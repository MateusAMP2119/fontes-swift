import SwiftUI

struct ActionsView: View {
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
                title: "As minhas Fontes",
                subtitle: "Cria ou edita páginas personalizadas.",
                systemImage: "newspaper.fill",
                isBeta: false,
                action: onMyFeed
            ),
            QuickAction(
                title: "Finder",
                subtitle: "Econtra páginas contruídas por outras pessoas.",
                systemImage: "magnifyingglass",
                isBeta: false,
                action: onFinder
            ),
            QuickAction(
                title: "Páginas colaborativas",
                subtitle: "Constroi páginas personalizdas em conjunto com amigos.",
                systemImage: "person.2",
                isBeta: false,
                action: onCollaborative
            )
        ]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Text("Feed Actions")
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .glassEffect(.regular.interactive())
                
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                            .glassEffect()
                    }
                    .padding(.trailing, 20)
                }
            }
            .padding(.bottom, 18)
            .padding(.top, 18)

            // Action rows
            VStack(spacing: 0) {
                ForEach(Array(quickActions.enumerated()), id: \.element.id) { index, item in
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
                    
                    if index < quickActions.count - 1 {
                        Divider()
                            .padding(.horizontal, 24)
                    }
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
            ActionsView()
        }
}
