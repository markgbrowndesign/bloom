//
//  ListView.swift
//  bloom
//
//  Created by Mark Brown on 23/05/2025.
//

import SwiftUI

struct ShopListView: View {
    
    @EnvironmentObject var shopRepository: CoffeeShopRepository
    
    var body: some View {
        NavigationStack {
            Group {
                switch shopRepository.shops {
                case .idle, .loading:
                    LoaderView(message: "Finding nearby coffee shops")
                case .loaded(let shops) where shops.isEmpty:
                    EmptyState(
                        title: "No Coffee Shops Found",
                        subtitle: "There were no coffee shops for the criteria you selected",
                        actionTitle: "Retry",
                        action: { Task { await shopRepository.loadShops() } }
                    )
                case .loaded(let shops):
                    CoffeeShopList(shops: shops)
                case .failed(let error):
                    ErrorView(
                        error: error,
                        actionLabel: "Retry",
                        action: { Task { await shopRepository.loadShops() } }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .scrollContentBackground(.hidden)
            .background(Theme.primaryBackground)
            .navigationTitle("All shops")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    IconButton(icon: "line.3.horizontal.decrease", action: {})
                }
            }
            .task {
                if case .idle = shopRepository.shops {
                    await shopRepository.loadShops()
                }
            }
            .refreshable {
                await shopRepository.loadShops()
            }
        }
    }
}

struct CoffeeShopList: View {
    
    let shops: [CoffeeShop]
    
    var body: some View {
        List {
            Section {
                ForEach(shops, id: \.id) { shop in
                    NavigationLink (destination: CoffeeShopView(shopId: shop.id)) {
                        ShopListItemView(shop: shop)
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    .foregroundStyle(Theme.textSecondary)
                }
            }
            .listRowBackground(Theme.sectionBackground)
            .listRowSeparatorTint(Theme.textPrimary.opacity(0.25))
            
            // Request footer
            Section {
                VStack(alignment: .center, spacing: 4) {
                    Text("Missing somewhere?")
                        .foregroundStyle(Theme.textSecondary)
                    
                    textButton(title: "Suggest a cafe") { }
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textButton)
                }
                .frame(maxWidth: .infinity)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0))
        }
    }
}

#Preview {
    ShopListView()
}
