//
//  CacheManager.swift
//  bloom
//
//  Created by Mark Brown on 26/05/2025.
//

import Foundation
import CoreLocation

class CacheManager {
    
    private let cache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let userDefaults = UserDefaults.standard
    private let cacheDirectory: URL
    
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    init() {
        self.cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cache.countLimit = 100
    }
    
    // Shop Repository Caching
    
    func saveShops(_ shops: [Shop], forLocation location: CLLocationCoordinate2D?) {
        let cacheData = ShopDataCache(
            shops: shops,
            userLocation: location,
            timestamp: Date()
        )
        
        let cacheKey = generateCacheKey(for: location)
        save(cacheData, forKey: cacheKey)
        
        userDefaults.set(cacheKey, forKey: "current_shop_cache_key")
        
        if let location = location {
            print("💾 Saved \(shops.count) shops with travel data for location: \(location.latitude), \(location.longitude)")
        } else {
            print("💾 Saved \(shops.count) shops without location data")
        }
    }
    
    func loadShops(forLocation location: CLLocationCoordinate2D?, maxAge: TimeInterval = 1800) -> [Shop]? {
        let cacheKey = generateCacheKey(for: location)
                
        guard isCacheValid(forKey: cacheKey, maxAge: maxAge),
              let cacheData = load(ShopDataCache.self, forKey: cacheKey) else {
            print("💾 No valid cache for location: \(location?.latitude ?? 0), \(location?.longitude ?? 0)")
            return nil
        }
        
        // If we have location, verify cached location is close enough
        if let currentLocation = location, let cachedLocation = cacheData.userLocation {
            let current = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            let cached = CLLocation(latitude: cachedLocation.latitude, longitude: cachedLocation.longitude)
            let distance = current.distance(from: cached)
            
            // If user moved more than 500m, invalidate cache
            if distance > 500 {
                print("💾 User moved too far (\(distance)m), invalidating cache")
                clearShopCache(forKey: cacheKey)
                return nil
            }
        }
        
        print("💾 Loaded \(cacheData.shops.count) shops from cache")
        return cacheData.shops
    }
    
    // Individual Shop Details Caching
    
    func saveShopDetails(_ shop: Shop, shopId: UUID) {
        let cacheKey = "shop_details_\(shopId)"
        save(shop, forKey: cacheKey)
    }
    
    func loadShopDetail(shopId: UUID, maxAge: TimeInterval = 600) -> Shop? {
        let cacheKey = "shop_details_\(shopId)"
        guard isCacheValid(forKey: cacheKey, maxAge: maxAge) else { return nil }
        return load(Shop.self, forKey: cacheKey)
    }
    
    // Cache management
    
    func clearShopCache(forKey key: String? = nil) {
        if let key = key {
            userDefaults.removeObject(forKey: key)
        } else {
            // Clear current cache
            if let currentKey = userDefaults.string(forKey: "current_shop_cache_key") {
                userDefaults.removeObject(forKey: currentKey)
                userDefaults.removeObject(forKey: "current_shop_cache_key")
            }
        }
        print("💾 Cleared shop cache")
    }
    
    func clearAllShopCaches() {
        let keys = userDefaults.dictionaryRepresentation().keys
        for key in keys where key.hasPrefix("shops_cache_") {
            userDefaults.removeObject(forKey: key)
        }
        userDefaults.removeObject(forKey: "current_shop_cache_key")
        print("💾 Cleared all shop caches")
    }
    
    // Private functions for generic caching (internal use only)
    
    func save<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            let cacheItem = CacheItem(data: data, timestamp: Date())
            let itemEncoder = JSONEncoder()
            if let itemData = try? itemEncoder.encode(cacheItem) {
                userDefaults.set(itemData, forKey: key)
            }
        } catch {
            print("Failed to cache object: \(error)")
            
        }
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T?{
        guard let data = userDefaults.data(forKey: key) else { return nil }
                
        let decoder = JSONDecoder()
        guard let cacheItem = try? decoder.decode(CacheItem.self, from: data) else { return nil }
        
        return try? JSONDecoder().decode(type, from: cacheItem.data)
    }
    
    func isCacheValid(forKey key: String, maxAge: TimeInterval = 300) -> Bool {
        guard let data = userDefaults.data(forKey: key) else { return false }
        
        let decoder = JSONDecoder()
        guard let cacheItem = try? decoder.decode(CacheItem.self, from: data) else { return false }
        
        return Date().timeIntervalSince(cacheItem.timestamp) < maxAge
    }
    
    func generateCacheKey(for location: CLLocationCoordinate2D?) -> String {
        if let location = location {
            let roundedLat = Double(round(1000 * location.latitude) / 1000)
            let roundedLong = Double(round(1000 * location.longitude) / 1000)
            return "shops_cache_\(roundedLat)_\(roundedLong)"
        } else {
            return "shops_cache_no_location"
        }
    }
}

struct CacheItem: Codable {
    let data: Data
    let timestamp: Date
}

struct ShopDataCache: Codable {
    let shops: [Shop]
    let userLocation: CLLocationCoordinate2D?
    let timestamp: Date
}

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
}
