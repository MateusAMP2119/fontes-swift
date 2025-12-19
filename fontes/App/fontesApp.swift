//
//  fontesApp.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

@main
struct fontesApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var userManager = UserManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(userManager)
        }
    }
}
