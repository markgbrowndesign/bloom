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
    
    @Published var coffeeShops: LoadingState<[CoffeeShop]> = .idle
    @Published var shopDetails: [UUID: LoadingState<CoffeeShop>] = [:]
        
    func loadShops(forceRefresh: Bool = false) async {
        await MainActor.run {
            coffeeShops = .loading
        }
        
        let cacheKey = "coffee_shops"
            
        if !forceRefresh,
           cacheManager.isCacheValid(forKey: cacheKey, maxAge: 300),
           let cachedShops = cacheManager.load([CoffeeShop].self, forKey: cacheKey) {
            await MainActor.run {
                coffeeShops = .loaded(cachedShops)
            }
            return
        }
        
        do {
            let shops = try await apiService.fetchShops()
            cacheManager.save(shops, forKey: cacheKey)
            await MainActor.run {
                coffeeShops = .loaded(shops)
            }
        } catch {
            await MainActor.run {
                coffeeShops = .failed(error)
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
           let cachedShop = cacheManager.load(CoffeeShop.self, forKey: cacheKey) {
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
