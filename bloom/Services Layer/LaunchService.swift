//
//  LaunchService.swift
//  bloom
//
//  Created by Mark Brown on 24/06/2025.
//

import Foundation
import CoreLocation

class LaunchService: ObservableObject {
    
    @Published var authState: AuthState = .checking
    @Published var locationPermissionState: LocationPermissionState = .checking
    
    @Published var isLaunchComplete = false
    
    func initialize() async {
        
        let stateService = StateService()
        
        let authState = await stateService.getAuthenticationState()
        print("currentAuthState: \(authState)")
        
        if authState == .unauthenticated {
            return
        }
        
        let locationState = await stateService.getLocationPermissions()
        print("currentLocationState: \(locationState)")
        
        if locationState == .granted {
            await getCurrentLocation()
        }
        
        
    }
    
    private func getCurrentLocation() async {
        
        let locationService = LocationService()
        
        do {
            
            locationService.requestLocation()
            let currentLocation = try await locationService.requestCurrentLocation()
            
            print("currentLocationFromFunc: \(currentLocation.latitude) - \(currentLocation.longitude)")
            print("currentLocationFromService: \(locationService.currentLocation?.latitude ?? 0) - \(locationService.currentLocation?.longitude ?? 0)")
        } catch {
            print("Error: \(error)")
        }
    }
    
}
