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
    
    var closestShop: CoffeeShop?
    var shops: [CoffeeShop] = []
    var isLoading = false
    var error: Error?
    
    private let shopRepository: CoffeeShopRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(shopRepository: CoffeeShopRepository) {
        self.shopRepository = shopRepository
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Note: We still use Combine here because we're observing the old-style ShopRepository
        // This will be cleaned up when we migrate ShopRepository later
        shopRepository.$shops
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadingState in
                self?.handleShopsUpdate(loadingState)
            }
            .store(in: &cancellables)
    }
    private func handleShopsUpdate(_ loadingState: LoadingState<[CoffeeShop]>) {
        switch loadingState {
        case .idle:
            isLoading = false
            
        case .loading:
            isLoading = true
            error = nil
            
        case .loaded(let shops):
            isLoading = false
            error = nil
            updateDiscoverContent(with: shops)
            
        case .failed(let error):
            isLoading = false
            self.error = error
            closestShop = nil
            shops = []
        }
    }
    
    private func updateDiscoverContent(with shops: [CoffeeShop]) {
        // Extract first 5 shops
        let discoverShops = Array(shops.prefix(5))
        
        // First shop becomes featured
        closestShop = discoverShops.first
        
        // Remaining shops (up to 4) become recent shops
        self.shops = Array(discoverShops.dropFirst().prefix(4))
    }
    
    func loadContent() {
        Task {
            await shopRepository.loadShops()
        }
    }
    
    func refreshContent() {
        Task {
            await shopRepository.loadShops(forceRefresh: true)
        }
    }
}
