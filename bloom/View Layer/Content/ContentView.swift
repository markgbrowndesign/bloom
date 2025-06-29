//
//  ContentView.swift
//  bloom
//
//  Created by Mark Brown on 23/05/2025.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @EnvironmentObject var appState: AuthService
    
    // Create a single instance that persists across the app
    @StateObject private var shopRepository = CoffeeShopRepository()
    @StateObject private var shopService = ShopService()
    
    private var viewModel = ContentViewModel()
    
    init() {
        
      // Navigation bar styling
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(hex: "#F2E1CAFF") ?? UIColor.green]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(hex: "#F2E1CAFF") ?? UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(hex: "#1A0D08FF") ?? UIColor.white
    }

    var body: some View {
        TabView {
            // Home/Discovery Tab
            DiscoverView(shopService: shopService)
            .tabItem {
                Image(systemName: "house")
                Text("Discover")
            }
            .toolbarBackground(Theme.primaryBackground, for: .tabBar)
                
            // List Tab
            ShopListView()
                .environmentObject(shopRepository)
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
        .onAppear() {
            // Trigger location request when app appears
            viewModel.checkLocationService()
        }
    }
}

#Preview {
    ContentView()
}
