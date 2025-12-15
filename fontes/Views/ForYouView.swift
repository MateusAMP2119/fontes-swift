//
//  ForYouView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct ForYouView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Recommended for you")
                        .padding()
                }
            }
            .navigationTitle("For You")
        }
    }
}

#Preview {
    ForYouView()
}
