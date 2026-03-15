//
//  CacheService.swift
//  bloom
//
//  Created by Mark Brown on 26/05/2025.
//

import Foundation

class CacheService {
    
    //MARK: - Private
    
    private class CacheEntry {
        let data: Data
        let cachedAt: Date
        
        init(data: Data, cachedAt: Date = Date()) {
            self.data = data
            self.cachedAt = cachedAt
        }
        
        func isValid(maxAge: TimeInterval) -> Bool {
            Date().timeIntervalSince(cachedAt) < maxAge
        }
    }
    
    private let cache = NSCache<NSString, CacheEntry>()
    
    init() {
        cache.countLimit = 100
    }
    
    //MARK: - Public Interface
    
    func save<T: Codable>(_ object: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(object) else {
            print("CacheService: Failed to encode object for key '\(key)'")
            return
        }
        cache.setObject(CacheEntry(data: data), forKey: key as NSString)
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String, maxAge: TimeInterval) -> T?{
        
        guard let entry = cache.object(forKey: key as NSString), entry.isValid(maxAge: maxAge) else { return nil }
        return try? JSONDecoder().decode(type, from: entry.data)
    }
    
    func clear(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearAll() {
        cache.removeAllObjects()
    }
}
