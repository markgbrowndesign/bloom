//
//  CoffeeShop.swift
//  bloom
//
//  Created by Mark Brown on 12/05/2025.
//

import Foundation

struct Shop: Codable, Identifiable {
    
    //name
    let id: UUID
    let name: String
    
    //description
    let longDescription: String?
    let shopURL: String?
    
    //address
    let addressArea: String
    let addressFirstLine: String?
    let addressSecondLine: String?
    
    //coodinates
    let coordinatesLongitude: Double?
    let coordinatesLatitude: Double?
    let distanceMeters: Double?
    
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
    let serviceOutdoorSeating: Bool?
    let serviceSellsBeans: Bool?
    
    //assets
    let imageLogoURL: String?
    let imageHeaderURL: String?
    
    //metadata
    let createdAt: String?
    let lastUpdatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name = "shop_name"
        case longDescription = "description"
        case shopURL = "shop_url"
        
        case addressArea = "address_area"
        case coordinatesLongitude = "coordinates_long"
        case coordinatesLatitude = "coordinates_lat"
        case addressFirstLine = "address_line_1"
        case addressSecondLine = "address_line_2"
        case distanceMeters = "distance_meters"
        
        case coffeeServed = "coffee_served"
        case equipmentGrinder = "equipment_grinder"
        case equipmentMachine = "equipment_machine"
        
        case serviceAccessible = "service_accessible"
        case serviceFoodCounter = "service_food_counter"
        case serviceFoodHot = "service_food_hot"
        case serviceWiFi = "service_wifi"
        case serviceSellsBeans = "service_sells_beans"
        case servicePowerOutlets = "service_power_outlets"
        case serviceParking = "service_parking"
        case servicePetFriendly = "service_dog_friendly"
        case serviceOutdoorSeating = "service_outdoor_seating"
        
        case imageLogoURL = "image_logo_url"
        case imageHeaderURL = "image_header_url"
        
        case createdAt = "created_at"
        case lastUpdatedAt = "updated_at"
    }
}
