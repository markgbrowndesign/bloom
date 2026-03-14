//
//  ShopService.swift
//  bloom
//
//  Created by Mark Brown on 17/06/2025.
//

import Foundation

@MainActor
class ShopService: ObservableObject {
    
    //private let locationService: LocationService
    private let apiService = APIService()
    
    func loadNearbyShops() async throws -> [Shop] {
        try await fetchNearby(limit: 4)
    }
    
    func loadAllShops() async throws -> [Shop] {
        try await fetchNearby(limit: 100)
    }
    
    func getShopDetails(shopId: UUID) async throws -> Shop {
        guard let shopDetails = try await apiService.fetchShopWith(id: shopId) else {
            throw ShopServiceError.shopNotFound
        }
        return shopDetails
    }
    
    //MARK: - Private
    
    private func fetchNearby(limit: Double) async throws -> [Shop] {
        guard let location = LocationService.shared.currentLocation else {
            throw ShopServiceError.locationUnavalible
        }
        
        return try await apiService.fetchNearbyShops(
            latitude: location.latitude,
            longitude: location.longitude,
            limit: limit
        )
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
