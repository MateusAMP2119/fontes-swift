import SwiftUI
import PhotosUI

struct ProfileSetupView: View {
    var onDone: () -> Void
    @Binding var username: String
    
    @State private var fullName: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title and Subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("PREENCHE O TEU PERFIL")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Podes alterar esta informação a qualqier momento")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 24)
            .padding(.top, 62)
            .padding(.bottom, 32)
            
            // Form Fields
            HStack(alignment: .top, spacing: 20) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(UIColor.systemGray6))
                            .frame(width: 80, height: 80)
                        
                        if let selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            VStack(spacing: 2) {
                                Image(systemName: "plus")
                                    .font(.system(size: 22))
                                    .foregroundColor(.gray)
                                Text("Foto")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = Image(uiImage: uiImage)
                        }
                    }
                }
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Nome", text: $fullName)
                            .font(.title3)
                            .padding(.leading, 4)
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Nome de Utilizador", text: $username)
                            .font(.title3)
                            .padding(.leading, 4)
                        
                        Divider()
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Done Button (Bottom)
            VStack {
                HStack {
                    Spacer()
                    Button(action: onDone) {
                        Text("Concluir")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .disabled(!isValid)
                    .padding()
                    .padding(.horizontal, 32)
                    .glassEffect(.regular.tint(isValid ? Color.baseRed : Color.gray).interactive())
                    Spacer()
                }
                .padding(.bottom, 16)
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    var isValid: Bool {
        !fullName.isEmpty && !username.isEmpty
    }
}

#Preview {
    ProfileSetupView(onDone: {}, username: .constant("PreviewUser"))
}
