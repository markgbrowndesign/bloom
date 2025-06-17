//
//  ShopService.swift
//  bloom
//
//  Created by Mark Brown on 17/06/2025.
//

import Foundation

@MainActor
class ShopService: ObservableObject {
    
    private let locationService: LocationService
    private let apiService = APIService()
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    func loadShops() async throws -> [Shop] {
        guard let location = locationService.currentLocation else {
            throw ShopServiceError.locationUnavalible
        }
        return try await apiService.fetchNearbyShops(latitude: location.latitude, longitude: location.longitude)
    }
    
    func refreshShops() async throws -> [Shop] {
        locationService.requestCurrentLocation()
        return try await loadShops()
    }
    
    func getShopDetails(shopId: UUID) async throws -> Shop {
        guard let shopDetails = try await apiService.fetchShopWith(id: shopId) else {
            throw ShopServiceError.shopNotFound
        }
        return shopDetails
    }
}

enum ShopServiceError: LocalizedError {
    case shopNotFound
    case locationUnavalible
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .shopNotFound:
            return "Shop not found"
        case .locationUnavalible:
            return "Location unavalible"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
