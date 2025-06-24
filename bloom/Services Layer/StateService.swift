//
//  StateService.swift
//  bloom
//
//  Created by Mark Brown on 24/06/2025.
//

import Foundation

class StateService: ObservableObject {
    
    @Published var authState: AuthState = .checking
    @Published var locState: LocationPermissionState = .checking
    
    func getAuthenticationState() async -> AuthState {
        
        for await state in supabase.auth.authStateChanges {
            if [.initialSession, .signedIn, .signedOut].contains(state.event) && state.session != nil {
                return .authenticated
            }
        }
        
        return .authenticated
        
    }
    
    func getLocationPermissions() async -> LocationPermissionState {
        
        let locationService = LocationService()
        switch locationService.authorizationStatus {
        case .notDetermined:
            return .notDetermined
        case .restricted, .denied:
            return .denied
        case .authorizedAlways, .authorizedWhenInUse:
            return .granted
        @unknown default:
            return .denied
        }
        
    }
    
}

enum AuthState {
    case checking
    case authenticated
    case unauthenticated
}

enum LocationPermissionState {
    case checking
    case granted
    case denied
    case notDetermined
    
}
