//
//  UserSettingsSidebar.swift
//  Fontes
//
//  Created by Mateus Costa on 10/01/2026.
//

import SwiftUI

struct UserSettingsSidebar: View {
    @Binding var isPresented: Bool
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Dimmed background
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isPresented = false
                        }
                    }
                    .transition(.opacity)
            }
            
            // Sidebar Content
            if isPresented {
                HStack(spacing: 0) {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // User Profile Header
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Text("MC")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.primary)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Mateus Costa")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.primary)
                                Text("mateus@example.com")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        
                        Divider()
                            .padding(.leading, 20)
                        
                        // Menu Items
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                
                                // Appearance Section
                                Toggle(isOn: $isDarkMode) {
                                    HStack(spacing: 12) {
                                        Image(systemName: isDarkMode ? "moon" : "sun.max")
                                            .font(.system(size: 20))
                                            .frame(width: 24)
                                            .foregroundColor(.primary.opacity(0.8))
                                        
                                        Text("Dark Mode")
                                            .font(.system(size: 16))
                                            .foregroundColor(.primary)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                
                                Divider()
                                    .padding(.leading, 56)

                                // Account Settings (Mock)
                                Button {
                                    // TODO: Navigate to account settings
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: "person")
                                            .font(.system(size: 20))
                                            .frame(width: 24)
                                            .foregroundColor(.primary.opacity(0.8))
                                        
                                        Text("Account Settings")
                                            .font(.system(size: 16))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                }
                                .buttonStyle(.plain)
                                
                                Divider()
                                    .padding(.leading, 56)
                                
                                // Privacy Policy
                                Button {
                                    // TODO: Open Link
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: "hand.raised")
                                            .font(.system(size: 20))
                                            .frame(width: 24)
                                            .foregroundColor(.primary.opacity(0.8))
                                        
                                        Text("Aviso de Privacidade")
                                            .font(.system(size: 16))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.up.right")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                }
                                .buttonStyle(.plain)
                                
                                Divider()
                                    .padding(.leading, 56)
                            }
                            .padding(.top, 8)
                        }
                        
                        Spacer()
                    }
                    .frame(width: 280) // Fixed width sidebar
                    .background(Color(uiColor: .systemBackground))
                    .edgesIgnoringSafeArea(.all)
                }
                .transition(.move(edge: .trailing))
            }
        }
        .zIndex(100)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        UserSettingsSidebar(isPresented: .constant(true))
    }
}
