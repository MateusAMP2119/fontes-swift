//
//  AlgorithmExpansion.swift
//  fontes
//
//  Created by Mateus Costa on 27/12/2025.
//

import SwiftUI

struct AlgorithmExpansion: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedAlgorithm: Algorithm?
    @Binding var algorithms: [Algorithm]
    var onAddAlgorithm: (Algorithm) -> Void
    var onDeleteAlgorithm: (IndexSet) -> Void
    
    @State private var isEditing = false
    
    // Alert/Sheet State
    @State private var showingAddSheet = false
    @State private var showingEditSheet = false
    @State private var editingAlgorithm: Algorithm?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                }
                
                Spacer()
                
                Text("Algorithms")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Edit Button
                Button(action: {
                    withAnimation {
                        isEditing.toggle()
                    }
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                }
            }
            .padding()
            .padding(.top, 10)
            
            // Content
            List {
                Section {
                    Button {
                        selectedAlgorithm = nil
                        dismiss()
                    } label: {
                        HStack {
                            Label("Default", systemImage: "sparkles")
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedAlgorithm == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Section("My Algorithms") {
                    ForEach(algorithms) { algorithm in
                        Button {
                            if isEditing {
                                editingAlgorithm = algorithm
                                showingEditSheet = true
                            } else {
                                selectedAlgorithm = algorithm
                                dismiss()
                            }
                        } label: {
                            HStack {
                                Label(algorithm.name, systemImage: "flowchart.fill")
                                    .foregroundColor(.primary)
                                Spacer()
                                if !isEditing && selectedAlgorithm?.id == algorithm.id {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                                if isEditing {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete(perform: onDeleteAlgorithm)
                }
                
                if isEditing {
                    Section {
                        Button(action: {
                            editingAlgorithm = nil
                            showingAddSheet = true
                        }) {
                            Label("Add New Algorithm", systemImage: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .environment(\.editMode, .constant(isEditing ? .active : .inactive))
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .sheet(isPresented: $showingAddSheet) {
                AlgorithmEditor(
                    title: "New Algorithm",
                    onSave: { newAlgo in
                        onAddAlgorithm(newAlgo)
                    }
                )
            }
            .sheet(isPresented: $showingEditSheet) {
                if let algo = editingAlgorithm {
                    AlgorithmEditor(
                        title: "Edit Algorithm",
                        algorithm: algo,
                        onSave: { updatedAlgo in
                            if let index = algorithms.firstIndex(where: { $0.id == updatedAlgo.id }) {
                                algorithms[index] = updatedAlgo
                                if selectedAlgorithm?.id == updatedAlgo.id {
                                    selectedAlgorithm = updatedAlgo
                                }
                            }
                        }
                    )
                }
            }
        }
        .background(Color(.systemBackground))
    }
}


