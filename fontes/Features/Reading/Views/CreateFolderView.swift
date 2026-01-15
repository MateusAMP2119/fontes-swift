//
//  CreateFolderView.swift
//  fontes
//
//  Created by Mateus Costa on 15/01/2026.
//

import SwiftUI
import PhotosUI

struct CreateFolderView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var feedStore = FeedStore.shared
    
    // Callback to pass the newly created folder details back
    var onCreate: (String, String?, String?) -> Void
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            if let selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(.systemGray4), lineWidth: 1)
                                    )
                            } else {
                                ZStack {
                                    Color(.systemGray6)
                                    Image(systemName: "camera.fill")
                                        .font(.title2)
                                        .foregroundStyle(.gray)
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Text(selectedImage == nil ? "Adicionar Foto" : "Alterar Foto")
                                    .font(.subheadline)
                                    .foregroundStyle(.red)
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        selectedImage = uiImage
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section("Detalhes") {
                    TextField("Nome da pasta", text: $name)
                    TextField("Descrição (opcional)", text: $description)
                }
            }
            .navigationTitle("Nova Pasta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Criar") {
                        createFolder()
                    }
                    .disabled(name.isEmpty)
                    .bold()
                    .tint(.red)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private func createFolder() {
        var imageFilename: String?
        
        if let selectedImage {
            imageFilename = feedStore.saveFeedImage(selectedImage)
        }
        
        let finalDescription = description.isEmpty ? nil : description
        
        onCreate(name, finalDescription, imageFilename)
        dismiss()
    }
}

#Preview {
    CreateFolderView { name, desc, img in
        print("Create: \(name), \(desc ?? ""), \(img ?? "")")
    }
}
