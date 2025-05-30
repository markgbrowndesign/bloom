//
//  EmptyState.swift
//  bloom
//
//  Created by Mark Brown on 28/05/2025.
//

import SwiftUI

func EmptyState(title: String, subtitle: String?, actionTitle: String?, action: (() -> Void)?) -> some View {
    VStack(alignment: .center, spacing: 16) {
        
        Image(systemName: "cup.and.saucer")
            .font(.system(size: 48))
            .foregroundColor(.secondary)
        
        VStack (spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)
            
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        
        if let actionTitle = actionTitle, let action = action {
            Button(actionTitle) {
                action()
            }
        }
    }
}
