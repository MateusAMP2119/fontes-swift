import SwiftUI
import PhotosUI

/// Profile setup screen matching Flipboard design (Screenshots 12-16)
/// - Red progress bar at top (nearly full)
/// - Bold uppercase title "PREENCHE O TEU PERFIL"
/// - Gray subtitle about editing later
/// - Circular photo placeholder with + icon and "Foto" label
/// - Full Name field with underline
/// - Username (Optional) field with underline
/// - Red "Concluir" button in keyboard toolbar
struct ProfileSetupView: View {
    var onDone: () -> Void
    @Binding var username: String
    
    @State private var fullName: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var showingImagePicker = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name
        case username
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar at top
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 3)
                    
                    Rectangle()
                        .fill(Color.baseRed)
                        .frame(width: geometry.size.width * 0.85, height: 3) // Nearly full
                }
            }
            .frame(height: 3)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PREENCHE O TEU PERFIL")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(.primary)
                        
                        Text("Altera a qualquer momento no ícone de engrenagem no teu Perfil")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .padding(.bottom, 40)
                    
                    // Circular Photo Picker
                    HStack {
                        Spacer()
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            ZStack {
                                Circle()
                                    .fill(Color(UIColor.systemGray5))
                                    .frame(width: 100, height: 100)
                                
                                if let selectedImage {
                                    selectedImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else {
                                    VStack(spacing: 4) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 24, weight: .medium))
                                            .foregroundColor(.gray)
                                        Text("Foto")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.bottom, 40)
                    .onChange(of: selectedItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImage = Image(uiImage: uiImage)
                            }
                        }
                    }
                    
                    // Name field with underline
                    VStack(spacing: 0) {
                        TextField("Nome Completo", text: $fullName)
                            .font(.system(size: 17))
                            .focused($focusedField, equals: .name)
                        
                        Rectangle()
                            .fill(focusedField == .name ? Color.baseRed : Color.gray.opacity(0.3))
                            .frame(height: 1)
                            .padding(.top, 12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Username field with underline
                    VStack(spacing: 0) {
                        TextField("Nome de utilizador (Opcional)", text: $username)
                            .font(.system(size: 17))
                            .focused($focusedField, equals: .username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        Rectangle()
                            .fill(focusedField == .username ? Color.baseRed : Color.gray.opacity(0.3))
                            .frame(height: 1)
                            .padding(.top, 12)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 100)
                }
            }
            
            Spacer()
            
            // Bottom Navigation
            HStack {
                Spacer()
                
                Button(action: onDone) {
                    HStack(spacing: 8) {
                        Text("Continuar")
                            .font(.system(size: 17, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(isValid ? Color.baseRed : Color.gray)
                    )
                }
                .disabled(!isValid)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .onAppear {
            focusedField = .name
        }
    }
    
    var isValid: Bool {
        !fullName.isEmpty
    }
}

#Preview {
    ProfileSetupView(onDone: {}, username: .constant(""))
}
