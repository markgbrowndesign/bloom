//
//  APIService.swift
//  bloom
//
//  Created by Mark Brown on 26/05/2025.
//

import Foundation
import Supabase

class APIService: ObservableObject {
    
    func fetchShops() async throws -> [CoffeeShop] {
        let data: [CoffeeShop] = try await supabase
            .from("coffee_shop")
            .select("id, shop_name, address_area")
            .execute()
            .value
        return data
    }
    
    func fetchNearbyShops(latitude: Double, longitude: Double, maxResults: Double = 20) async throws -> [CoffeeShop] {
        let data: [CoffeeShop] = try await supabase
            .rpc("nearby_coffee_shops", params: [
                "user_lat": latitude,
                "user_long": longitude,
                "max_results": maxResults
            ])
            .execute()
            .value
        
        print("Returned from function: \(data)")
        
        return data
    }
    
    func fetchShopWith(id: UUID) async throws -> CoffeeShop? {
        print("get shop with id: \(id)")
        
        let data: CoffeeShop = try await supabase
            .from("coffee_shop")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
        
        print(data)
        return data
    }
    
    func fetchUserWith(id: UUID) async throws -> Profile? {
        
        print("id \(id)")
        
        let data: Profile = try await supabase
            .from("profiles")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
        
        print("data: \(data)")
        return data
    }
    
}

enum LoadingState<T> {
    case idle
    case loading
    case loaded(T)
    case failed(Error)
}
