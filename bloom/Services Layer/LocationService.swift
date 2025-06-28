//
//  LocationManager.swift
//  bloom
//
//  Created by Mark Brown on 28/05/2025.
//

import Swift
import CoreLocation
import MapKit

class LocationService: NSObject, ObservableObject {

    private let service = CLLocationManager()
    
    public static var shared = LocationService()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var locationError: Error?
    
    override init() {
        self.authorizationStatus = CLLocationManager().authorizationStatus
        super.init()
        
        service.delegate = self
        service.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        if authorizationStatus == .notDetermined {
            requestLocationPermission()
        } else if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            requestCurrentLocation()
        }
    }
    
    func requestLocationPermission() {
        service.requestWhenInUseAuthorization()
    }
    
    func requestCurrentLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            if authorizationStatus == .notDetermined {
                requestLocationPermission()
            }
            return
        }
    
        service.requestLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location: \(locations.first?.coordinate.latitude), \(locations.first?.coordinate.longitude)")
        currentLocation = locations.first?.coordinate
        locationError = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        locationError = error
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        switch status {
        case .restricted, .denied:
            locationError = NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied. Please enable location services in Settings."])
        case .authorizedWhenInUse, .authorizedAlways:
            requestCurrentLocation()
        default:
            locationError = NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "❓ Unknown location authorization status"])
        }
    }
    
}
