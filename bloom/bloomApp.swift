//
//  bloomApp.swift
//  bloom
//
//  Created by Mark Brown on 11/05/2025.
//

import SwiftUI

@main
struct bloomApp: App {
    
    @StateObject var appState = AuthService()
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appState)
        }
    }
}
