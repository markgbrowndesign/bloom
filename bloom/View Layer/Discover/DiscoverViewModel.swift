//
//  DiscoverViewModel.swift
//  bloom
//
//  Created by Mark Brown on 15/06/2025.
//

import Foundation
import Observation

@Observable
class DiscoverViewModel {
    
    var closestShop: Shop?
    var shops: [Shop] = []
    var isLoading = false
    var error: Error?
    
    private let shopService: ShopService
    
    var hasShops: Bool {
        closestShop != nil || !shops.isEmpty
    }
    
    init(shopService: ShopService) {
        self.shopService = shopService
    }
    
    func loadContent() async {
        
        isLoading = true
        error = nil
        
        do {
            let shops = try await shopService.loadShops()
            await MainActor.run {
                updateContent(with: shops)
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                print("error from load content")
                isLoading = false
            }
        }
    }
    
    func refresh() async {
        await loadContent()
    }
    
    // MARK: - Private Methods
    
    private func updateContent(with shops: [Shop]) {
        // Extract first 5 shops
        let discoverShops = Array(shops.prefix(5))
        
        // First shop becomes featured
        closestShop = discoverShops.first
        
        // Remaining shops (up to 4) become recent shops
        self.shops = Array(discoverShops.dropFirst().prefix(4))
    }
    
}
