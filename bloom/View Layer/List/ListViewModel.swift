//
//  ListViewModel.swift
//  bloom
//
//  Created by Mark Brown on 26/05/2025.
//

import Foundation
import Combine

class ShopListViewModel: ObservableObject {
    
    @Published var shops: [Shop] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showEmptyState = false
    
    var shopRepository: ShopRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(shopRepository: ShopRepository) {
        
        self.shopRepository = shopRepository
        
        shopRepository.$shops
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadingState in
                switch loadingState {
                case .idle:
                    self?.isLoading = false
                case .loading:
                    self?.isLoading = true
                    self?.error = nil
                case .loaded(let shops):
                    self?.isLoading = false
                    self?.shops = shops
                    self?.showEmptyState = shops.isEmpty
                case .failed(let error):
                    self?.isLoading = false
                    self?.error = error
                    self?.showEmptyState = true
                }
            }
            .store(in: &cancellables)
    }
    
    func loadShops(forceRefresh: Bool = false) {
        
        Task {
            await shopRepository.loadShops(forceRefresh: forceRefresh)
        }
    }
    
    func refreshShops() {
        loadShops(forceRefresh: true)
    }
}
