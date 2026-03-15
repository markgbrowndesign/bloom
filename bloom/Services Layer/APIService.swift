//
//  APIService.swift
//  bloom
//
//  Created by Mark Brown on 26/05/2025.
//

import Foundation
import Supabase

class APIService {
    
    func fetchShops() async throws -> [Shop] {
        let data: [Shop] = try await supabase
            .from("coffee_shop")
            .select("id, shop_name, address_area")
            .execute()
            .value
        return data
    }
    
    func fetchNearbyShops(latitude: Double, longitude: Double, limit: Double = 4, maxDistance: Double = 25) async throws -> [Shop] {
        
        do {
            let data: [Shop] = try await supabase
                .rpc("nearby_coffee_shops", params: [
                    "latitude": latitude,
                    "longitude": longitude,
                    "max_distance": maxDistance,
                    "response_limit": limit
                ])
                .execute()
                .value
            return data
        } catch {
            print("throwing from here")
            throw error
        }
    }
    
    func fetchShopWith(id: UUID) async throws -> Shop? {
        let data: Shop = try await supabase
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
