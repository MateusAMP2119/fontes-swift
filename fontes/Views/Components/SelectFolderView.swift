
import SwiftUI

struct SelectFolderView: View {
    // This environment variable allows the 'X' button to close the sheet
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                // 1. Custom Row for "Send Message"
                // We use an HStack to build the custom green icon layout
                HStack(spacing: 12) {
                    Image(systemName: "bubble.left.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.green)
                        .cornerRadius(8) // Rounded corners for the icon
                    
                    VStack(alignment: .leading) {
                        Text("Send Message")
                            .foregroundColor(.primary)
                        Text("1 shortcut")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // 2. Standard Row for "New Folder"
                // The 'badge' modifier on the system image handles the plus sign
                Label {
                    Text("New Folder")
                } icon: {
                    Image(systemName: "folder.badge.plus")
                        .foregroundColor(.blue)
                }

                // 3. Standard Row for "All Shortcuts"
                Label {
                    Text("All Shortcuts")
                } icon: {
                    Image(systemName: "tray.full") // Or "square.stack.3d.up"
                        .foregroundColor(.blue)
                }
            }
            // --- Navigation Bar Styling ---
            .navigationTitle("Select a folder")
            .navigationBarTitleDisplayMode(.inline) // Forces the small center title
            .toolbar {
                // The Close Button on the top left
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .padding(8)
                    }
                }
            }
        }
    }
}

// Preview to see it in action
#Preview {
    SelectFolderView()
}
