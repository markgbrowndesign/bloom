//
//  APIService.swift
//  bloom
//
//  Created by Mark Brown on 26/05/2025.
//

import Foundation
import Supabase

class APIService {
    
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
        return data
    }
    
    func fetchShopWith(id: UUID) async throws -> CoffeeShop? {
        let data: CoffeeShop = try await supabase
            .from("coffee_shop")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
        return data
    }
    
    func fetchUserWith(id: UUID) async throws -> Profile? {
        let data: Profile = try await supabase
            .from("profiles")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
        return data
    }
    
}

enum LoadingState<T> {
    case idle
    case loading
    case loaded(T)
    case failed(Error)
}
