//
//  Environment+BottomContentHeight.swift
//  Fontes
//
//  Created by Mateus Costa on 15/01/2026.
//

import SwiftUI

private struct BottomContentHeightKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    var bottomContentHeight: CGFloat {
        get { self[BottomContentHeightKey.self] }
        set { self[BottomContentHeightKey.self] = newValue }
    }
}
