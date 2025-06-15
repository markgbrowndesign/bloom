//
//  ContentView.swift
//  bloom
//
//  Created by Mark Brown on 23/05/2025.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    // Create a single instance that persists across the app
    @StateObject private var locationService = LocationManager()
    @StateObject private var shopRepository: CoffeeShopRepository
    
    init() {
        
        //initalise repository with location service
        let locationService = LocationManager()
        self._locationService = StateObject(wrappedValue: locationService)
        self._shopRepository = StateObject(wrappedValue: CoffeeShopRepository())
        
      // Navigation bar styling
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(hex: "#F2E1CAFF") ?? UIColor.green]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(hex: "#F2E1CAFF") ?? UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(hex: "#1A0D08FF") ?? UIColor.white
    }

    var body: some View {
        TabView {
            // Home/Discovery Tab
            ShopListView()
                .environmentObject(shopRepository)
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
        .onAppear {
            // Trigger location request when app appears
            if locationService.authorizationStatus == .notDetermined {
                locationService.requestLocationPermission()
            }
        }
//          TODO: Fix location change update
//        .onChange(of: locationService.currentLocation) { oldLocation, newLocation in
//            if let old = oldLocation, let new = newLocation {
//                let oldCoordinate = CLLocation(latitude: old.latitude, longitude: old.longitude)
//                let newCoordinate = CLLocation(latitude: new.latitude, longitude: new.longitude)
//                if oldCoordinate.distance(from: newCoordinate) > 500 { // 500m threshold
//                    Task {
//                        await shopRepository.refreshWithLocation()
//                    }
//                }
//            } else if newLocation != nil && oldLocation == nil {
//                // First time getting location
//                Task {
//                    await shopRepository.refreshWithLocation()
//                }
//            }
//        }
    }
}

#Preview {
    ContentView()
}
