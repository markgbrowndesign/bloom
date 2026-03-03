//
//  ImageService.swift
//  bloom
//
//  Created by Mark Brown on 26/02/2026.
//

import Foundation
import UIKit
import CryptoKit

class ImageService: NSObject, ObservableObject {
    
    public static var shared = ImageService()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    
    private let diskCacheDirectory: URL
    
    private var activeTasks: [String: Task<UIImage?, Never>] = [:]
    
    private let taskLock = NSLock()
    
    private override init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.diskCacheDirectory = caches.appendingPathComponent("Images", isDirectory: true)
        
        try? FileManager.default.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
        
        memoryCache.countLimit = 200
    }
    
    func loadImage(for shopID: UUID?, imageType: ImageServiceImageType) async -> UIImage? {
        guard let id = shopID?.uuidString else { return nil }
        var imageName: String
        
        switch imageType {
        case .logo:
            imageName = imageType.pngImage
        case .thumbnail, .header:
            imageName = imageType.jpgImage
        }
        
        return await loadImage(for: "\(id.lowercased())/\(imageName)")
    }
    
    func loadImage(for path: String) async -> UIImage? {
        
        if let cached = getFromMemory(path: path) {
            return cached
        }
        
        if let diskImage = getFromDisk(path: path) {
            saveToMemory(image: diskImage, path: path)
            return diskImage
        }
        
        let key = path.replacingOccurrences(of: "/", with: "-")
        
        // Atomically check for existing task or create a new one
        let task: Task<UIImage?, Never> = taskLock.withLock {
            if let existingTask = activeTasks[key] {
                return existingTask
            }
            let newTask = Task<UIImage?, Never> {
                defer {
                    self.taskLock.withLock { self.activeTasks.removeValue(forKey: key) }
                }
                guard let data = try? await supabase.storage
                    .from("shop-images")
                    .download(path: path)
                else {
                    print("no data at \(path)")
                    return nil
                }
                guard let image = UIImage(data: data) else {
                    print("no image")
                    return nil
                }
                self.saveToMemory(image: image, path: path)
                self.saveToDisk(data: data, path: path)
                return image
            }
            activeTasks[key] = newTask
            return newTask
        }
        
        return await task.value
    }
    
    func clearCache() {
        memoryCache.removeAllObjects()
        try? FileManager.default.removeItem(at: diskCacheDirectory)
        try? FileManager.default.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
    }
    
    private func cacheKey(for path: String) -> String {
        let hash = SHA256.hash(data: Data(path.utf8))
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    private func getFromMemory(path: String) -> UIImage? {
        memoryCache.object(forKey: path as NSString)
    }
    
    private func saveToMemory(image: UIImage, path: String) {
        memoryCache.setObject(image, forKey: path as NSString)
    }
    
    private func getFromDisk(path: String) -> UIImage? {
        let fileURL = diskCacheDirectory.appendingPathComponent(cacheKey(for: path))
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
    
    private func saveToDisk(data: Data, path: String) {
        let fileURL = diskCacheDirectory.appendingPathComponent(cacheKey(for: path))
        try? data.write(to: fileURL)
    }

}

enum ImageServiceImageType: String {
    
    case thumbnail
    case header
    case logo
    
    var jpgImage: String { "\(rawValue).jpg" }
    var pngImage: String { "\(rawValue).png" }
    
}
