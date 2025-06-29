//
//  AppRootView.swift
//  bloom
//
//  Created by Mark Brown on 11/05/2025.
//

import SwiftUI

struct AppRootView: View {

    @EnvironmentObject var appState: AuthService
    
    var body: some View {
        ZStack {
            switch appState.authState {
            case .checking:
                //Splash view
                Text("checking")
                    .task {
                        await appState.getAuthState()
                    }
                    .transition(.opacity)
            case .authenticated:
                ContentView()
                    .environmentObject(appState)
            case .unauthenticated:
                AuthView()
                    .transition(.opacity)
            }
        }
        .animation(.easeIn(duration: 0.5), value: appState.authState)
    }
    
    
    
}

