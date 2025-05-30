//
//  ProfileModel.swift
//  bloom
//
//  Created by Mark Brown on 24/05/2025.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    
    var id: UUID?
    var email: String
    var username: String
    
    var imageURL: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case email
        case username
        
        case imageURL = "avatar_url"
        case updatedAt = "updated_at"
        
    }
}

enum TravelMethod: String, CaseIterable, Codable {
    
    case walking
    case cycling
    case driving
    case publicTransport
    
}

enum MeaurementUnit: String, CaseIterable, Codable {
    
    case metric
    case imperial
    
}
