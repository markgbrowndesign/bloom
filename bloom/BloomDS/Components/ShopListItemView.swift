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
    
    let shopName: String
    let shopLogoSource: String
    let shopArea: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(shopLogoSource)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(.rect(cornerRadius: 8))
            VStack(alignment: .leading) {
                Text(shopName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                    
                HStack {
                    Text(shopArea)
                }
            }
        }
    }
}
