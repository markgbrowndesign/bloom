//
//  DiscoverViewModel.swift
//  bloom
//
//  Created by Mark Brown on 15/06/2025.
//

import Foundation
import Observation
import Combine

@Observable
class DiscoverViewModel {
    
    var shops: [Shop] = []
    var isLoading = false
    var error: Error?
    
    var closestShop: Shop? { shops.first }
    var nearbyShops: [Shop] { Array(shops.dropFirst()) }
    var hasShops: Bool { !shops.isEmpty }
    
    let shopService: ShopService
    
    //MARK: - Private
    
    private var cancellables = Set<AnyCancellable>()
    
    init(shopService: ShopService) {
        self.shopService = shopService
        observeLocation()
    }
    
    func loadContent() async {
        guard shops.isEmpty else { return }
        await fetchShops()
    }
    
    func refreshContent() async {
        ImageService.shared.clearCache()
        await fetchShops()
    }
    
    // MARK: - Private Methods
    
    private func observeLocation() {
        LocationService.shared.$currentLocation
            .compactMap { $0 }
            .first()
            .sink { [weak self] _ in
                guard let self, self.shops.isEmpty else { return }
                Task { await self.fetchShops() }
            }
            .store(in: &cancellables)
    }
    
    private func fetchShops() async {
        isLoading = true
        error = nil
        
        do {
                let result = try await shopService.loadNearbyShops()
                print("DiscoverViewModel fetched \(result.count) shops")
                shops = result
            } catch {
                print("DiscoverViewModel error: \(error)")
                self.error = error
            }
        
        isLoading = false
    }
    
}
