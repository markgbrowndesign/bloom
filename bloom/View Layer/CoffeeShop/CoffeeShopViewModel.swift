//
//  CoffeeShopViewModel.swift
//  bloom
//
//  Created by Mark Brown on 12/05/2025.
//

import Foundation
import MapKit
import Observation
   
@Observable
class CoffeeShopViewModel {
    
    var shop: Shop?
    var isLoading = false
    var error: Error?
    var travelTime: TimeInterval?
    
    private let shopService: ShopService
    
    init(shopService: ShopService) {
        self.shopService = shopService
    }
    
    func loadShop(shopId: UUID) async {

        isLoading = true
        error = nil
        
        do {
            shop = try await shopService.getShopDetails(shopId: shopId)
        } catch {
            self.error = error
        }
        
        isLoading = false
        
    }
    
    func refresh(shopId: UUID) async {
        await loadShop(shopId: shopId)
    }
    
    func onTapDirections() {
        
        guard
            let shop = shop,
            let shopLatitude = shop.coordinatesLatitude,
            let shopLongitude = shop.coordinatesLongitude
                else { return }
        
        let fullAddress = String("\(shop.addressFirstLine), \(shop.addressSecondLine)")
        let shortAddress = shop.addressFirstLine
        let location = CLLocation(latitude: shopLatitude, longitude: shopLongitude)
        
        let mapItem = MKMapItem(location: location, address: MKAddress(fullAddress: fullAddress, shortAddress: shortAddress))
        mapItem.name = shop.name
        
      
        
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
