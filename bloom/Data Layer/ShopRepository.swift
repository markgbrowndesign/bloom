//
//  CoffeeShopRepository.swift
//  bloom
//
//  Created by Mark Brown on 27/05/2025.
//

import Foundation
import CoreLocation

class ShopRepository: ObservableObject {
    private let apiService = APIService()
    private let cacheManager = CacheManager()
    private let locationService: LocationService
    
    //TODO: Get rid of coffeeShops & closestShop
    @Published var shops: LoadingState<[Shop]> = .idle
    @Published var shopDetails: [UUID: LoadingState<Shop>] = [:]
    
    var closestShop: Shop? {
        switch shops {
        case .loaded(let shopsArray):
            return shopsArray.first
        default:
            return nil
        }
    }
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
        
    func loadShops(forceRefresh: Bool = false) async {
        await MainActor.run {
            shops = .loading
        }
        
        let currentLocation = locationService.currentLocation
            
        if !forceRefresh,
           let cachedShops = cacheManager.loadShops(forLocation: currentLocation, maxAge: 1800) {
            await MainActor.run {
                shops = .loaded(cachedShops)
            }
            return
        }
        
        do {
            let shopDetails = try await apiService.fetchShops()
            
            let shops: [Shop]
            if let location = currentLocation {
                shops = await locationService.enrichCoffeeShopsWithLocationData(shopDetails)
            } else {
                shops = shopDetails.map {
                    Shop(details: $0, distance: nil, travelTime: nil, isCalculating: false)
                }
            }
            cacheManager.saveShops(shops, forLocation: currentLocation)
            
            await MainActor.run {
                self.shops = .loaded(shops)
            }
            
        } catch {
            await MainActor.run {
                self.shops = .failed(error)
            }
        }
    }
    
    func loadShopDetails(shop: Shop, forceRefresh: Bool = false) async {
        await MainActor.run {
            shopDetails[shop.id] = .loading
        }
        
        if !forceRefresh,
           let cachedShop = cacheManager.loadShopDetail(shopId: shop.id, maxAge: 600) {
            await MainActor.run {
                shopDetails[shop.id] = .loaded(cachedShop)
            }
            return
        }
        
        do {
            guard let shopDetail = try await apiService.fetchShopWith(id: shop.id) else { return }
            let shop = Shop(
                details: shopDetail,
                distance: shop.distance,
                travelTime: shop.travelTime,
                isCalculating: shop.isCalculating)
            
            cacheManager.saveShopDetails(shop, shopId: shop.id)
            
            await MainActor.run {
                shopDetails[shop.id] = .loaded(shop)
            }
        } catch {
            await MainActor.run {
                shopDetails[shop.id] = .failed(error)
            }
        }
    }
    
    func clearCache() {
        cacheManager.clearAllShopCaches()
    }
    
    func refreshWithLocation() async {
        cacheManager.clearShopCache()
        await loadShops(forceRefresh: true)
    }
}
