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
            VStack {
                Spacer()
                
                Text("For you page")
                
                Spacer()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ForYouView()
}
