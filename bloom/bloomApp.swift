//
//  bloomApp.swift
//  bloom
//
//  Created by Mark Brown on 11/05/2025.
//

import SwiftUI

@main
struct bloomApp: App {
    
    @StateObject private var appState = StateService()
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appState)
        }
    }
}

struct AppRootView: View {
    
    @EnvironmentObject var appState: StateService
    
    var body: some View {
        ZStack {
            switch appState.authState {
            case .checking:
                SplashView()
                    .transition(.opacity)
            case .authenticated:
                ContentView()
                    .environmentObject(ShopService(locationService: LocationService()))
            case .unauthenticated:
                AuthView()
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.authState)
    }
    
}
