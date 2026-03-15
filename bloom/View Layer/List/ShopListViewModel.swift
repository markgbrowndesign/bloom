//
//  ShopListViewModel.swift
//  bloom
//
//  Created by Mark Brown on 26/05/2025.
//

import Foundation
import Combine

class ShopListViewModel {
    
    var shops: [Shop] = []
    var isLoading = false
    var error: Error?
    
    let shopService: ShopService
    
    //MARK: - Private
    private var cancellables: Set<AnyCancellable> = []
    
    init(shopService: ShopService) {
        self.shopService = shopService
        observeLocation()
    }
    
    func loadShops() async {
        guard shops.isEmpty else { return }
        await fetchShops()
    }
    
    func refreshShops() async {
       await fetchShops()
    }
    
    //MARK: - Private
    
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
            shops = try await shopService.loadAllShops()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
}
