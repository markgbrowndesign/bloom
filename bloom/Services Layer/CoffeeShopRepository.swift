//
//  CoffeeShopRepository.swift
//  bloom
//
//  Created by Mark Brown on 27/05/2025.
//

import Foundation

class CoffeeShopRepository: ObservableObject {
    private let apiService = APIService()
    private let cacheManager = CacheManager()
    private let locationManager = LocationService()
    
    @Published var shops: LoadingState<[Shop]> = .idle
    @Published var shopDetails: [UUID: LoadingState<Shop>] = [:]
    
    func loadShops(forceRefresh: Bool = false) async {
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            await loadNeabyShops(forceRefresh: forceRefresh)
        case .notDetermined, .denied, .restricted :
            await loadAllShops(forceRefresh: forceRefresh)
        default:
            await loadAllShops(forceRefresh: forceRefresh)
        }
        
    }
        
    func loadNeabyShops(forceRefresh: Bool = false) async {
        await MainActor.run {
            shops = .loading
        }
        
        guard let currentLocation = locationManager.currentLocation else {
            await loadShops(forceRefresh: forceRefresh)
            return
        }
        
        let cacheKey = "coffee_shops_\(currentLocation.latitude)_\(currentLocation.longitude)"
        
        if !forceRefresh,
           cacheManager.isCacheValid(forKey: cacheKey, maxAge: 1800),
           let cachedShops = cacheManager.load([Shop].self, forKey: cacheKey) {
            await MainActor.run {
                shops = .loaded(cachedShops)
            }
            return
        }
        
        do {
            let nearbyShops = try await apiService.fetchNearbyShops(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            
            cacheManager.save(nearbyShops, forKey: cacheKey)
            
            await MainActor.run {
                self.shops = .loaded(nearbyShops)
            }
        } catch {
            await MainActor.run {
                self.shops = .failed(error)
            }
        }
    }
    func loadAllShops(forceRefresh: Bool = false) async {
        await MainActor.run {
            self.shops = .loading
        }

        let cacheKey = "coffee_shops"
            
        if !forceRefresh,
           cacheManager.isCacheValid(forKey: cacheKey, maxAge: 300),
           let cachedShops = cacheManager.load([Shop].self, forKey: cacheKey) {
            await MainActor.run {
                self.shops = .loaded(cachedShops)
            }
            return
        }
        
        do {
            let shops = try await apiService.fetchShops()
            cacheManager.save(shops, forKey: cacheKey)
            await MainActor.run {
                self.shops = .loaded(shops)
            }
        } catch {
            await MainActor.run {
                self.shops = .failed(error)
            }
        }
    }
    
    func loadShopDetails(shopId: UUID, forceRefresh: Bool = false) async {
        await MainActor.run {
            shopDetails[shopId] = .loading
        }
        
        let cacheKey = "shop_\(shopId)"
        
        if !forceRefresh,
           cacheManager.isCacheValid(forKey: cacheKey, maxAge: 600),
           let cachedShop = cacheManager.load(Shop.self, forKey: cacheKey) {
            await MainActor.run {
                shopDetails[shopId] = .loaded(cachedShop)
            }
            return
        }
        
        do {
            guard let shop = try await apiService.fetchShopWith(id: shopId) else { return }
            cacheManager.save(shop, forKey: cacheKey)
            
            await MainActor.run {
                shopDetails[shopId] = .loaded(shop)
            }
        } catch {
            await MainActor.run {
                shopDetails[shopId] = .failed(error)
            }
        }
    }
}
