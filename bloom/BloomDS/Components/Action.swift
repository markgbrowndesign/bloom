//
//  Action.swift
//  bloom
//
//  Created by Mark Brown on 17/05/2025.
//
import Foundation
import SwiftUI

func actionButton(icon: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Image(systemName: icon)
            .frame(width: 40, height: 40)
            .foregroundStyle(Theme.textPrimary)
    }
    .frame(width: 56, height: 56, alignment: .center)
    .background(Theme.actionBackground)
    .clipShape(Circle())
    .glassEffect(.regular.interactive(), in: .circle)

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
        .frame(maxWidth: .infinity)
    }
    .foregroundStyle(Theme.primaryBackground)
    .background(Theme.buttonBackground)
    .clipShape(.capsule)
    .glassEffect(.regular.interactive())
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

#Preview("Buttons") {
    VStack(spacing: 16) {
        
        
        HStack(spacing: 8) {
            primaryButton(title: "Get directions") { }
            actionButton(icon: "plus") { }
        }
        
        textButton(title: "Suggest a cafe") { }
        
        IconButton(icon: "arrow.clockwise") { }
    }
    .padding()
    .background(Theme.primaryBackground) // your dark background so colours read correctly
}
