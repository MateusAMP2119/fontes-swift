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
            VStack {
                Spacer()
                
                Text("For later page")
                
                Spacer()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ForLaterView()
}
