//
//  ShopListItemView.swift
//  bloom
//
//  Created by Mark Brown on 28/05/2025.
//

import SwiftUI

struct ShopListItemLargeView: View {
    
    let shopName: String
    let shopLogoSource: String
    let shopHeaderSource: String
    let shopDistance: String
    let shopTravelTime: String
    let shopDescription: String
    
    var body: some View {
        VStack() {
            Image(shopHeaderSource)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: .infinity, height: 192, alignment: .center)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4){
                Text(shopName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text(shopDistance)
                    Text("•")
                    Text(shopTravelTime)
                }
                
                Text(shopDescription)
                
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .padding(.top, 8)
            .foregroundStyle(Theme.textSecondary)
        }
    }
}

struct ShopListItemView: View {
    
    let enrichedShop :Shop
    
    var body: some View {
        HStack(spacing: 16) {
            Image("shop_logo_list")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(.rect(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(enrichedShop.details.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                    
                HStack(spacing: 4) {
                    Text(enrichedShop.details.addressArea)
                    
                    if let distance = enrichedShop.distance {
                        Text("•")
                        Text(formatDistance(distance))
                    }
                }
            }
        }
    }
    
    func formatDistance(_ distance: Double, unit: MeaurementUnit = .metric) -> String {
        switch unit {
        case .metric:
            let km = distance / 1000.0
            return km < 10 ? String(format: "%.1fkm", km) : String(format: "%.0fkm", km)
        case .imperial:
            let formatter = MeasurementFormatter()
            formatter.unitOptions = .naturalScale
            formatter.numberFormatter.maximumFractionDigits = 1
            formatter.locale = Locale(identifier: "en_US") // Force imperial
            
            let meters = Measurement(value: distance, unit: UnitLength.meters)
            return formatter.string(from: meters)
        }
    }
    
    func formatTime(_ timeInterval: TimeInterval) -> String {
        
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes) min"
        }
        
    }
}
