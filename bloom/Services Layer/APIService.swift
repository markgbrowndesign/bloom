//
//  APIService.swift
//  bloom
//
//  Created by Mark Brown on 26/05/2025.
//

import Foundation
import Supabase

class APIService: ObservableObject {
    
    func fetchShops() async throws -> [ShopDetail] {
        let data: [ShopDetail] = try await supabase
            .from("coffee_shop")
            .select("id, shop_name, address_area, coordinates_lat, coordinates_long")
            .execute()
            .value
        return data
    }
    
    func fetchShopWith(id: UUID) async throws -> ShopDetail? {
        print("get shop with id: \(id)")
        
        let data: ShopDetail = try await supabase
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
    
    var value: T? {
        switch self {
        case .loaded(let value):
            return value
        default:
            return nil
        }
    }
}
