//
//  MenuCoordination.swift
//  Fontes
//
//  Created by Mateus Costa on 24/12/2025.
//

import SwiftUI

struct ActiveMenuIdKey: EnvironmentKey {
    static let defaultValue: Binding<String?> = .constant(nil)
}

extension EnvironmentValues {
    var activeMenuId: Binding<String?> {
        get { self[ActiveMenuIdKey.self] }
        set { self[ActiveMenuIdKey.self] = newValue }
    }
}
