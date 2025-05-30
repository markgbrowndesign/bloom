//
//  CoffeeShop.swift
//  bloom
//
//  Created by Mark Brown on 12/05/2025.
//

import Foundation

struct CoffeeShop: Codable, Identifiable {
    
    //name
    let id: UUID
    let name: String
    
    //description
    let shortDescription: String?
    let longDescription: String?
    let shopURL: String?
    
    //address
    let addressArea: String
    let addressFirstLine: String?
    let addressSecondLine: String?
    
    //coodinates
    let coordinatesLongitude: Double?
    let coordinatesLatitude: Double?
    
    //equipment
    let coffeeServed: String?
    let equipmentGrinder: String?
    let equipmentMachine: String?
    
    //service details
    let serviceAccessible: Bool?
    let serviceFoodCounter: Bool?
    let serviceFoodHot: Bool?
    let serviceWiFi: Bool?
    let servicePowerOutlets: Bool?
    let serviceParking: Bool?
    let servicePetFriendly: Bool?
    let serviceOutdoor: Bool?
    let serviceSellsCoffee: Bool?
    
    //assets
    let imageLogo: String?
    let imageHeader: String?
    
    //metadata
    let createdAt: String?
    let lastUpdatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name = "shop_name"
        case shortDescription = "short_description"
        case longDescription = "long_description"
        case shopURL = "website_url"
        
        case addressArea = "address_area"
        case coordinatesLongitude = "coordinates_long"
        case coordinatesLatitude = "coordinates_lat"
        case addressFirstLine = "first_address_line"
        case addressSecondLine = "second_address_line"
        
        case coffeeServed = "coffee_served"
        case equipmentGrinder = "equipment_grinder"
        case equipmentMachine = "equipment_machine"
        
        case serviceAccessible = "service_accessible"
        case serviceFoodCounter = "service_food_counter"
        case serviceFoodHot = "service_food_hot"
        case serviceWiFi = "service_wifi"
        case serviceSellsCoffee = "service_sells_coffee"
        case servicePowerOutlets = "service_power_outlets"
        case serviceParking = "service_parking"
        case servicePetFriendly = "service_dog_friendly"
        case serviceOutdoor = "service_outdoor"
        
        case imageLogo = "image_logo"
        case imageHeader = "image_header"
        
        case createdAt = "created_at"
        case lastUpdatedAt = "last_updated"
    }
}
