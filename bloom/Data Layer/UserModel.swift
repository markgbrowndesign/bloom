//
//  ProfileModel.swift
//  bloom
//
//  Created by Mark Brown on 24/05/2025.
//

import Foundation

struct Profile: Codable, Identifiable, Hashable {
    
    var id: UUID?
    var email: String
    var username: String
    
    var preferredTravelMethod: TravelMethod
    var measurementUnit: MeaurementUnit
    
    var imageURL: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case email
        case username
        
        case preferredTravelMethod = "preferred_travel_method"
        case measurementUnit = "measurement_unit"
        
        case imageURL = "avatar_url"
        case updatedAt = "updated_at"
        
    }
}

enum TravelMethod: String, CaseIterable, Codable {
    
    case walking = "walking"
    //case cycling = "cycling"
    case driving = "driving"
    case publicTransport = "public_transport"
    
}

enum MeaurementUnit: String, CaseIterable, Codable {
    
    case metric
    case imperial
    
}

enum UserProfileProperty: String {
    
    case measurementUnit
    case travelMethod
    case imageURL
    case username
    case email
    case notificationPreferences
    
}

class User: ObservableObject {
    private let apiService = APIService()
    private let cacheManager = CacheManager()
    
    @Published var profile: [UUID: LoadingState<Profile>] = [:]
    
    func loadUserProfile(userId: UUID, forceRefresh: Bool = false) async {
        await MainActor.run {
            profile[userId] = .loading
        }
        
        let cacheKey = "userProfile_\(userId)"
        
        if !forceRefresh,
           cacheManager.isCacheValid(forKey: cacheKey, maxAge: 600),
           let cachedUserProfile = cacheManager.load(Profile.self, forKey: cacheKey) {
               await MainActor.run {
                   profile[userId] = .loaded(cachedUserProfile)
               }
               return
        }
        
        do {
            guard let profile = try await apiService.fetchUserWith(id: userId) else { return }
            cacheManager.save(profile, forKey: cacheKey)
            
            await MainActor.run {
                self.profile[userId] = .loaded(profile)
            }
        } catch {
            await MainActor.run {
                self.profile[userId] = .failed(error)
            }
        }
    }
    
}

