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
            .scrollContentBackground(.hidden)
            .background(Theme.primaryBackground)
            .navigationTitle("Bloom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    IconButton(icon: "arrow.clockwise") {
                        Task { await viewModel.refresh() }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: .vertical)
        .task {
            await viewModel.loadContent()
        }
    }
    
    @ViewBuilder
    private var DiscoverContentView: some View {
    
        List {
            if let closestShop = viewModel.closestShop {
                Section {
                    ZStack(alignment: .leading) {
                        NavigationLink (destination: CoffeeShopView(shopId: closestShop.id)) {
                            EmptyView()
                        }
                        .opacity(0)
                        ShopListItemLargeView(shop: closestShop)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
            } header: {
                Text("Nearby")
                    .font(.title2)
                    .textCase(.none)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                    .foregroundStyle(Theme.textSecondary)
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
