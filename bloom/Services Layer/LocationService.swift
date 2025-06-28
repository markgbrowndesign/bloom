//
//  LocationManager.swift
//  bloom
//
//  Created by Mark Brown on 28/05/2025.
//

import Swift
import CoreLocation
import MapKit

@MainActor
class LocationService: NSObject, ObservableObject {

    private let service = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var locationError: Error?
    @Published var isLocationLoading = false
    
    override init() {
        self.authorizationStatus = CLLocationManager().authorizationStatus
        super.init()
        
        service.delegate = self
        service.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        if authorizationStatus == .notDetermined {
            requestLocationPermission()
        }
        
    }
    
    func requestLocationPermission() {
        service.requestWhenInUseAuthorization()
    }
    
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D {
        print("requestCurrentLocation: Start")
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            if authorizationStatus == .notDetermined {
                requestLocationPermission()
            }
            throw LocationError.notAuthorized
        }
    
        if let currentLocation = currentLocation {
            print("currentLocationAlreadySet")
            return currentLocation
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            print("withCheckedThrowingContinuation")
            self.locationContinuation = continuation
            
            self.isLocationLoading = true
            
            print("requestLocation")
            service.requestLocation()
            
        }
    }
    
    func requestLocation() {
        print("requestLocation")
        service.requestLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations: Start")
        
        guard let location = locations.first?.coordinate else { return }
        
        DispatchQueue.main.async {
            self.currentLocation = location
            self.locationError = nil
            self.isLocationLoading = false
        }
        
        if let continuation = locationContinuation {
            print("didUpdateLocations: Continuation")
            locationContinuation = nil
            continuation.resume(returning: location)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("didFailWithError: Start")
        DispatchQueue.main.async {
            self.locationError = error
            self.isLocationLoading = false
        }
        
        if let continuation = locationContinuation {
            print("didFailWithError: Continuation")
            locationContinuation = nil
            continuation.resume(throwing: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("authStatusDidChange: Start")
        authorizationStatus = status
        switch status {
        case .restricted, .denied:
            
            let error = LocationError.notAuthorized
            locationError = error
            
            if let continuation = locationContinuation {
                print("authStatusDidChange: Continuation")
                locationContinuation = nil
                continuation.resume(throwing: error)
            }
            
        case .authorizedWhenInUse, .authorizedAlways:
            return
            //requestCurrentLocation()
        default:
            locationError = NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "❓ Unknown location authorization status"])
        }
    }
    
}

enum LocationError: Error, LocalizedError {
    case notAuthorized
    case locationUnavailable
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Location access denied. Please enable location services in Settings."
        case .locationUnavailable:
            return "Location unavailable."
        case .timeout:
            return "Location request timed out."
        }
    }
}
