//
//  SearchView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Discover page")
                
                Spacer()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    SearchView()
}
