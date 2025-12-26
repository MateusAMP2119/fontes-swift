//
//  TodayHeader.swift
//  fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct TodayHeaderView: View {
    var body: some View {
        HStack(alignment: .center) {
            Image("header_light")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 62)
            
            Spacer()
        }
    }
}

#Preview {
    TodayHeaderView()
}
