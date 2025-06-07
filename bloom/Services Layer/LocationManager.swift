//
//  LocationManager.swift
//  bloom
//
//  Created by Mark Brown on 28/05/2025.
//

import Swift
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {

    private let manager = CLLocationManager()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var locationError: Error?
    @Published var isLocationLoading = false
    
    override init() {
        self.authorizationStatus = CLLocationManager().authorizationStatus
        super.init()
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        print("location services initialised with status \(authorizationStatus)")
        
        if authorizationStatus == .notDetermined {
            requestLocationPermission()
        } else if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            requestCurrentLocation()
        }
    }
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestCurrentLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            if authorizationStatus == .notDetermined {
                requestLocationPermission()
            }
            return
        }
        
        isLocationLoading = true
        manager.requestLocation()
    }
    
    func calculateDistance(to shop: CoffeeShop) -> CLLocationDistance? {
        guard let currentLocation = currentLocation,
              let shopLat = shop.coordinatesLatitude,
              let shopLong = shop.coordinatesLongitude else {
            print("❌ Missing location data for distance calculation")
            return nil
        }
        
        print("🏠 User location: \(currentLocation.latitude), \(currentLocation.longitude)")
        print("☕️ Shop '\(shop.name)' location: \(shopLat), \(shopLong)")
        
        let shopLocation = CLLocation(latitude: shopLat, longitude: shopLong)
        let userLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        return userLocation.distance(from: shopLocation)
    }
    
    func calculateTravelTime(to shop: CoffeeShop, using transportType: MKDirectionsTransportType = .walking) async -> TimeInterval? {
        
        guard let currentLocation = currentLocation,
              let shopLat = shop.coordinatesLatitude,
              let shopLong = shop.coordinatesLongitude else {
            return nil
        }
        
        let destination = CLLocationCoordinate2D(latitude: shopLat, longitude: shopLong)
        
        let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation))
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        
        let request = MKDirections.Request()
        request.destination = destinationItem
        request.source = sourceItem
        request.transportType = transportType
        
        let directions = MKDirections(request: request)
        
        do {
            let response = try await directions.calculate()
            return response.routes.first?.expectedTravelTime
        } catch {
            return nil
        }
        
    }
    
    func enrichCoffeeShopsWithLocationData(_ shops: [CoffeeShop]) async -> [EnrichedCoffeeShop] {
        
        guard currentLocation != nil else {
            return shops.map { EnrichedCoffeeShop(details: $0, distance: nil, travelTime: nil, isCalculating: false) }
        }
        
        var enrichedShops: [EnrichedCoffeeShop] = []
        
        for shop in shops {
            let distance = calculateDistance(to: shop)
            let travelTime = await calculateTravelTime(to: shop)
            
            let enrichedCoffeeShop = EnrichedCoffeeShop(
                details: shop,
                distance: distance,
                travelTime: travelTime,
                isCalculating: false
            )
            enrichedShops.append(enrichedCoffeeShop)
        }
        
        let sortedShops = enrichedShops.sorted { (shop1, shop2) in
            guard let distance1 = shop1.distance, let distance2 = shop2.distance else {
                return shop1.distance != nil
            }
            return distance1 < distance2
        }
        
        print("✅ Enriched and sorted \(sortedShops.count) shops")
        return sortedShops
    }

}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first?.coordinate
        locationError = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        locationError = error
        print("Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        switch status {
        case .restricted, .denied:
            print("❌ Location permission denied/restricted")
            locationError = NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied. Please enable location services in Settings."])
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location permission granted")
            requestCurrentLocation()
        default:
            print("❓ Unknown location authorization status")
        }
    }
    
}
