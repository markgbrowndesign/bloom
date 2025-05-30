//
//  CoffeeShopViewModel.swift
//  bloom
//
//  Created by Mark Brown on 12/05/2025.
//

import Foundation
import Supabase
import Combine
    
class CoffeeShopViewModel: ObservableObject {
    
    @Published var shop: CoffeeShop?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let repository = CoffeeShopRepository()
    private var cancellable = Set<AnyCancellable>()
    
    func loadShop(shopId: UUID, forceRefresh: Bool = false) {
        repository.$shopDetails
            .compactMap { $0[shopId] }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadingState in
                switch loadingState {
                case .idle:
                    self?.isLoading = false
                case .loading:
                    self?.isLoading = true
                    self?.error = nil
                case .loaded(let shop):
                    self?.isLoading = false
                    self?.shop = shop
                case .failed(let error):
                    self?.isLoading = false
                    self?.error = error
                }
            }
            .store(in: &cancellable)
        Task {
            await repository.loadShopDetails(shopId: shopId, forceRefresh: forceRefresh)
        }
    }
    
}
