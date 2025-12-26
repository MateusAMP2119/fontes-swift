//
//  ToolbarComponent.swift
//  fontes
//
//  Created by Mateus Costa on 19/12/2025.
//

import SwiftUI

struct ToolbarComponent: View {
    @EnvironmentObject var userManager: UserManager

    var body : some View {
        NavigationLink(destination: ProfileProgressScreen()) {
            HStack(spacing: 8.0) {
                HStack(spacing: 4.0) {
                    Image(systemName: "moonphase.full.moon.inverse")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 18.0)
                        .foregroundStyle(.orange)
                    Text("12")
                        .font(.system(size: 15.0, weight: .bold))
                }
                
                Rectangle()
                    .fill(Color.primary.opacity(0.2))
                    .frame(width: 1.0, height: 18.0)
                
                if let user = userManager.currentUser {
                    // Logged in user
                    if let imageName = user.profileImageName {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        // Fallback if no image name
                        Image(systemName: "person.circle.fill")
                    }
                } else {
                    // Guest user
                    Image(systemName: "person.crop.circle")
                }
            }
            
        }
    }
}

#Preview {
    ToolbarComponent()
        .environmentObject(UserManager())
}
