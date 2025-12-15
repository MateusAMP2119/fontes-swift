//
//  ForLaterView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct ForLaterView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("Saved items will appear here")
            }
            .navigationTitle("For Later")
        }
    }
}

#Preview {
    ForLaterView()
}
