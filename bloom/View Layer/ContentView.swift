//
//  ContentView.swift
//  bloom
//
//  Created by Mark Brown on 23/05/2025.
//

import SwiftUI

struct ContentView: View {
    
    // Create a single instance that persists across the app
    @StateObject private var locationManager = LocationManager()
    
    init() {
      // Large Navigation Title
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(hex: "#F2E1CAFF") ?? UIColor.green]
      // Inline Navigation Title
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(hex: "#F2E1CAFF") ?? UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(hex: "#1A0D08FF") ?? UIColor.white
    }

    var body: some View {
        TabView {
            // Home/Discovery Tab
            ListView()
            .tabItem {
                Image(systemName: "house")
                Text("Discover")
            }
            .toolbarBackground(Theme.primaryBackground, for: .tabBar)
                
            // List Tab
            ListView()
            .foregroundStyle(Theme.textPrimary)
            .tabItem {
                Image(systemName: "list.bullet")
                Text("List")
            }
            .toolbarBackground(Theme.primaryBackground, for: .tabBar)
        
            // Profile Tab
            NavigationStack {
                ProfileView()
                    .toolbar {
                        IconButton(icon: "rectangle.portrait.and.arrow.forward", action: {})
                    }
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            .toolbarBackground(Theme.primaryBackground, for: .tabBar)
        }
        .tint(Theme.textButton)
        .onAppear {
            // Trigger location request when app appears
            if locationManager.authorizationStatus == .notDetermined {
                print("🚀 App appeared, requesting location permission...")
                locationManager.requestLocationPermission()
            }
        }
    }
}

#Preview {
    ContentView()
}
