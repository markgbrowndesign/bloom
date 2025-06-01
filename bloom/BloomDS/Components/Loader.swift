//
//  Loader.swift
//  bloom
//
//  Created by Mark Brown on 27/05/2025.
//

import SwiftUI

func LoaderView(message: String) -> some View {
    VStack(spacing: 16) {
        ProgressView()
            .scaleEffect(1.2)
            .foregroundStyle(Theme.textSecondary)
        Text(message)
            .foregroundStyle(Theme.textSecondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
