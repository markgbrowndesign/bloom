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
    
    func loadShops() async throws -> LoadingState<[Shop]> {
        
        guard let currentLocation = LocationService.shared.currentLocation else {
            //TODO: Add in fallback method
            let error = NSError(domain: "", code: 0, userInfo: ["": ""])
            return .failed(error)
        }

        let cacheKey = "coffee_shops_\(currentLocation.latitude)_\(currentLocation.longitude)"

//        TODO: Add in local loading
//        if !forceRefresh,
//           cacheManager.isCacheValid(forKey: cacheKey, maxAge: 1800),
//           let cachedShops = cacheManager.load([Shop].self, forKey: cacheKey) {
//            await MainActor.run {
//                shops = .loaded(cachedShops)
//            }
//            return
//        }

        do {
            let nearbyShops = try await apiService.fetchNearbyShops(latitude: currentLocation.latitude, longitude: currentLocation.longitude)

            //cacheManager.save(nearbyShops, forKey: cacheKey)
            return LoadingState.loaded(nearbyShops)
        } catch {
            return LoadingState.failed(error)
        }
        
    }
    
    func refreshShops() async throws -> LoadingState<[Shop]> {
        LocationService.shared.requestCurrentLocation()
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
