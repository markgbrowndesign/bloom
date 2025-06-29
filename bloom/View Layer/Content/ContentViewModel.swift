//
//  ContentViewModel.swift
//  bloom
//
//  Created by Mark Brown on 29/06/2025.
//

import Foundation

class ContentViewModel {
    
    
    func checkLocationService() {
        if LocationService.shared.authorizationStatus == .notDetermined {
            LocationService.shared.requestLocationPermission()
        }
    }
    
}
