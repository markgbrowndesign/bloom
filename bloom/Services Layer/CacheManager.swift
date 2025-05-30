//
//  CacheManager.swift
//  bloom
//
//  Created by Mark Brown on 26/05/2025.
//

import Foundation


class CacheManager {
    
    private let cache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        self.cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cache.countLimit = 100
    }
    
    func save<T: Codable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            cache.setObject(data as NSData, forKey: key as NSString)
            
            let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
            try data.write(to: fileURL)
        } catch {
            print("Failed to cache object: \(error)")
            
        }
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T?{
        // Check memory cache
        if let data = cache.object(forKey: key as NSString) as Data? {
            return try? JSONDecoder().decode(type, from: data)
        }
        
        // Check local stroage
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    func isCacheValid(forKey key: String, maxAge: TimeInterval = 300) -> Bool {
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        guard let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
              let modificationDate = attributes[.modificationDate] as? Date else {
            return false
        }
        return Date().timeIntervalSince(modificationDate) < maxAge
    }
}
