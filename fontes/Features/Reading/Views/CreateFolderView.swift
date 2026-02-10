//
//  CreateFolderView.swift
//  Fontes
//
//  Created by Mateus Costa on 15/01/2026.
//

import SwiftUI
import PhotosUI

struct CreateFolderView: View {
    @ObservedObject var feedStore = FeedStore.shared
    
    // Callback to pass the newly created folder details back
    var onCreate: (String, String?, String?) -> Void
    var onCancel: () -> Void
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Nova Pasta")
                .font(.headline)
            
            // Image Picker
            VStack {
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
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
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Text(selectedImage == nil ? "Adicionar Foto" : "Alterar Foto")
                        .font(.caption)
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
            
            // Text Fields
            VStack(spacing: 12) {
                TextField("Nome da pasta", text: $name)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                TextField("Descrição (opcional)", text: $description)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Actions
            HStack(spacing: 12) {
                Button(action: onCancel) {
                    Text("Cancelar")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Button(action: {
                    createFolder()
                }) {
                    Text("Criar")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(name.isEmpty ? Color.gray.opacity(0.3) : Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(name.isEmpty)
            }
        }
        .padding(24)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        .frame(maxWidth: 320)
    }
    
    private func createFolder() {
        var imageFilename: String?
        
        if let selectedImage {
            imageFilename = feedStore.saveFeedImage(selectedImage)
        }
        
        let finalDescription = description.isEmpty ? nil : description
        
        onCreate(name, finalDescription, imageFilename)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        CreateFolderView(
            onCreate: { name, desc, img in
                print("Create: \(name), \(desc ?? ""), \(img ?? "")")
            },
            onCancel: {}
        )
    }
}
