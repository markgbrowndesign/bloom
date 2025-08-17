//
//  DiscoverViewModel.swift
//  bloom
//
//  Created by Mark Brown on 15/06/2025.
//

import Foundation
import Observation
import Combine

class DiscoverViewModel: ObservableObject {
    
    var closestShop: Shop?
    var shops: [Shop] = []
    @Published var discoverIsLoading = false
    var error: Error?
    var showEmptyState = false
    
    let shopRepository: CoffeeShopRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(shopRepository: CoffeeShopRepository) {
        
        self.shopRepository = shopRepository
        self.shopRepository.$shops
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadingState in
                switch loadingState {
                case .idle:
                    self?.discoverIsLoading = false
                case .loading:
                    self?.discoverIsLoading = true
                    self?.error = nil
                case .loaded(let shops):
                    self?.discoverIsLoading = false
                    self?.updateContent(with: shops)
                    self?.showEmptyState = false
                case .failed(let error):
                    self?.discoverIsLoading = false
                    self?.error = error
                    self?.showEmptyState = true
                }
            }
            .store(in: &cancellables)
        
    }
    
    var hasShops: Bool {
        closestShop != nil
    }
    
    func loadContent(forceRefresh: Bool = false) async {
        
        Task {
            await shopRepository.loadShops(forceRefresh: forceRefresh)
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
