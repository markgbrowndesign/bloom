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
    
    func fetchUserWith(id: UUID) async throws -> User {
        let data: User = try await supabase
            .from("profiles")
            .select()
            .eq("id", value: id)
            .limit(1)
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
