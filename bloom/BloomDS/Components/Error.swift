//
//  Error.swift
//  bloom
//
//  Created by Mark Brown on 28/05/2025.
//

import SwiftUI

func ErrorView(error: Error, actionLabel: String, action: @escaping () -> Void) -> some View {
    
    VStack {
        Text("Error: \(error.localizedDescription), other stuff")
        Button(actionLabel) {
            action()
        }
    }

}
