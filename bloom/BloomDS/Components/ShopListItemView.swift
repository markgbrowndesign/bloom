//
//  ShopListItemView.swift
//  bloom
//
//  Created by Mark Brown on 28/05/2025.
//

import SwiftUI

struct ShopListItemLargeView: View {
    
    let shop: Shop
    
    var body: some View {
        VStack() {
            Image("coffee_shop_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 192, alignment: .center)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4){
                Text(shop.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text(shop.addressArea)
                    if let distance = shop.distanceMeters {
                        Text("•")
                        Text(distance.formatAsDistance())
                    }
                }
                if let description = shop.longDescription {
                    Text(description)
                        .truncationMode(.tail)
                }
                
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .padding(.top, 8)
            .foregroundStyle(Theme.textSecondary)
        }
    }
}

struct ShopListItemView: View {
    
    let shop: Shop
    
    var body: some View {
        HStack(spacing: 16) {
            Image("shop_logo_list")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(.rect(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(shop.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                    
                HStack(spacing: 4) {
                    Text(shop.addressArea)
                    
                    if let distance = shop.distanceMeters {
                        Text("•")
                        Text(distance.formatAsDistance())
                    }
                }
            }
        }
    }
}
