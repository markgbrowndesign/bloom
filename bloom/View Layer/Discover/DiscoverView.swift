//
//  DiscoverView.swift
//  bloom
//
//  Created by Mark Brown on 23/05/2025.
//

import SwiftUI

struct DiscoverView: View {
    
    @State private var viewModel: DiscoverViewModel
    
    init(shopService: ShopService) {
        self._viewModel = State(wrappedValue: DiscoverViewModel(shopService: shopService))
    }
    
    var body: some View {
        
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    LoaderView(message: "Finding coffee...")
                } else if let error = viewModel.error {
                    ErrorView(
                        error: error,
                        actionLabel: "Try again",
                        action: {
                            Task { await viewModel.refresh() }
                        }
                    )
                } else if viewModel.hasShops {
                    DiscoverContentView
                } else {
                    EmptyDiscoverView
                }
            }
            .navigationTitle("Bloom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    IconButton(icon: "arrow.clockwise") {
                        Task { await viewModel.refresh() }
                    }
                }
            }
        }
        .task {
            await viewModel.loadContent()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: .vertical)
        .background(Theme.primaryBackground)
    }
    
    @ViewBuilder
    private var DiscoverContentView: some View {
    
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
        .background(Theme.primaryBackground)
    }
    
    @ViewBuilder
    private var EmptyDiscoverView: some View {
        Text("empty")
    }
    
}
