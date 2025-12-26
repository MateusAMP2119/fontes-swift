//
//  TabAccessoryFilter.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct TabAccessoryFilter: View {
    var onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: "circle.hexagonpath")
                .font(.system(size: 22))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    TabAccessoryFilter(onTap: { print("Filter tapped") })
        .padding()
}
