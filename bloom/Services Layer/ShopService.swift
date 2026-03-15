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
    private let cacheService = CacheService()
    
    private let nearbyShopsKey = "nearby_shops"
    private let allShopsKey = "all_shops"
    
    private let nearbyShopsTTL: TimeInterval = 5 * 60
    private let allShopsTTL: TimeInterval = 60 * 60
    private let shopDetailsTTL: TimeInterval = .infinity
    
    func loadNearbyShops() async throws -> [Shop] {
        if let cached = cacheService.load([Shop].self, forKey: nearbyShopsKey, maxAge: nearbyShopsTTL) {
            return cached
        }
        let shops = try await fetchNearby(limit: 4)
        cacheService.save(shops, forKey: nearbyShopsKey)
        return shops
    }
    
    func loadAllShops() async throws -> [Shop] {
        if let cached = cacheService.load([Shop].self, forKey: allShopsKey, maxAge: allShopsTTL) {
            return cached
        }
        let shops = try await fetchNearby(limit: 100)
        cacheService.save(shops, forKey: allShopsKey)
        return shops
    }
    
    func getShopDetails(shopId: UUID) async throws -> Shop {
        
        let cacheKey = "shop_\(shopId.uuidString)"
        if let cached = cacheService.load(Shop.self, forKey: cacheKey, maxAge: shopDetailsTTL) {
            return cached
        }
        
        guard let shop = try await apiService.fetchShopWith(id: shopId) else {
            throw ShopServiceError.shopNotFound
        }
        
        return shop
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
