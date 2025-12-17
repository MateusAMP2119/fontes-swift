import SwiftUI

struct BuildAlgorithmView: View {
    @Environment(\.dismiss) var dismiss
    @State private var algoName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Algorithm Details")) {
                    TextField("Name", text: $algoName)
                }
                
                Section(header: Text("Topics")) {
                    Toggle("Technology", isOn: .constant(true))
                    Toggle("Science", isOn: .constant(false))
                    Toggle("Politics", isOn: .constant(false))
                    Toggle("Design", isOn: .constant(true))
                }
                
                Section(header: Text("Sources")) {
                    Toggle("Major Publications", isOn: .constant(true))
                    Toggle("Independent Blogs", isOn: .constant(true))
                }
            }
            .navigationTitle("New Algorithm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
        }
    }
}
