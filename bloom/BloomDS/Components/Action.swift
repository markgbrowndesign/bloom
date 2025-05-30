//
//  Action.swift
//  bloom
//
//  Created by Mark Brown on 17/05/2025.
//
import Foundation
import SwiftUI

func actionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 16, height: 16)
                .padding(.top, 12)
            Text(title)
                .font(.caption)
                .padding(.bottom, 12)
        }
    }
    .frame(maxWidth: .infinity)
    .background(Theme.actionBackground)
    .clipShape(.buttonBorder)
    .foregroundColor(Theme.textSecondary)
}

func primaryButton(icon: String? = nil, title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        HStack(spacing: 4) {
            if icon?.isEmpty == false {
                Image(systemName: icon ?? "")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.vertical, 16)
            }
            Text(title)
                .fontWeight(.bold)
                .padding(.vertical, 16)
        }
    }
    .frame(maxWidth: .infinity)
    .foregroundStyle(Theme.primaryBackground)
    .background(Theme.buttonBackground)
    .clipShape(.buttonBorder)
}

func textButton(title: String, action: @escaping () -> Void) -> some View {
    
    Button(action: action) {
        Text(title)
            .fontWeight(.bold)
    }
    
}

func IconButton(icon: String, action: @escaping () -> Void) -> some View {
    
    Button(action: action) {
        Image(systemName: icon)
            .frame(width: 24, height: 24)
            .foregroundStyle(Theme.textPrimary)
    }
    .frame(width: 36, height: 36, alignment: .center)
    .background(Theme.actionBackground)
    .clipShape(Circle())

}
