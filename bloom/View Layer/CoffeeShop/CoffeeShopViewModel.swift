//
//  CoffeeShopViewModel.swift
//  bloom
//
//  Created by Mark Brown on 12/05/2025.
//

import Foundation
import Supabase
import Combine
import MapKit
    
class CoffeeShopViewModel: ObservableObject {
    
    @Published var shop: Shop?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var travelTime: TimeInterval?
    
    private let repository = CoffeeShopRepository()
    private var cancellable = Set<AnyCancellable>()
    private let locationManager = LocationService()
    
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
    
    func onTapDirections() {
        
        guard let shopLatitude = shop?.coordinatesLatitude, let shopLongitude = shop?.coordinatesLongitude else { return }
        
        let location = CLLocationCoordinate2D(latitude: shopLatitude, longitude: shopLongitude)
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location, addressDictionary: nil))
        mapItem.name = shop?.name ?? ""
        
      
        
//        let method: Any
//        switch userObject.preferredTravelMethod {
//        case .driving:
//            method = MKLaunchOptionsDirectionsModeDriving
//        case .walking:
//            method = MKLaunchOptionsDirectionsModeWalking
//        case .publicTransport:
//            method = MKLaunchOptionsDirectionsModeTransit
//        }
        
        let launchOptions: [String : Any] = [
            MKLaunchOptionsDirectionsModeKey :
                MKLaunchOptionsDirectionsModeTransit,
                MKLaunchOptionsShowsTrafficKey: false
            ]
        MKMapItem.openMaps(with: [mapItem], launchOptions: launchOptions)
            
        
    }
    
}
