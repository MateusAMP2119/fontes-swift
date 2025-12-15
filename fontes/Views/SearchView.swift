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
            List {
                Text("Search Results will appear here")
            }
            .navigationTitle("Search")
        }
    }
}

#Preview {
    SearchView()
}
