//
//  TodayView.swift
//  fontes
//
//  Created by Mateus Costa on 15/12/2025.
//

import SwiftUI

struct TodayView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Hello, world!")
                
                Spacer()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    TodayView()
}
