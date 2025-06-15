//
//  DiscoverView.swift
//  bloom
//
//  Created by Mark Brown on 23/05/2025.
//

import SwiftUI

struct DiscoverView: View {
    
    @State private var viewModel: DiscoverViewModel
    
    init(shopRepository: CoffeeShopRepository) {
        self._viewModel = State(wrappedValue: DiscoverViewModel(shopRepository: shopRepository))
    }
    
    var body: some View {
        List {
            if let closestShop = viewModel.closestShop {
                Section {
                    NavigationLink (destination: CoffeeShopView(shopId: closestShop.id)) {
                        ShopListItemLargeView(shop: closestShop)
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    .foregroundStyle(Theme.textSecondary)
                }
                .listRowBackground(Theme.sectionBackground)
                .listRowSeparatorTint(Theme.textPrimary.opacity(0.25))

            }
            Section {
                ForEach(viewModel.shops, id: \.id) { shop in
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .scrollContentBackground(.hidden)
        .background(Theme.primaryBackground)
        .task {
            viewModel.loadContent()
        }
        .refreshable {
            viewModel.refreshContent()
        }
    }
}
