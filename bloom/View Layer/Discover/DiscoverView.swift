//
//  DiscoverView.swift
//  bloom
//
//  Created by Mark Brown on 23/05/2025.
//

import SwiftUI

struct DiscoverView: View {
    
    @State private var viewModel: DiscoverViewModel
    
    init(shopRepositroy: CoffeeShopRepository) {
        self._viewModel = State(wrappedValue: DiscoverViewModel(shopRepository: shopRepositroy))
    }
    
    var body: some View {
        
        NavigationStack {
            Group {
                switch viewModel.shopRepository.shops {
                case .idle, .loading:
                    LoaderView(message: "Finding coffee...")
                case .loaded(let shops) where shops.isEmpty:
                    EmptyState(
                        title: "No Coffee Shops Found",
                        subtitle: "There were no coffee shops for the criteria you selected",
                        actionTitle: "Retry",
                        action: { Task { await viewModel.shopRepository.loadShops() } }
                    )
                case .loaded(let shops):
                    DiscoverContentView(shops: shops)
                case .failed(let error):
                    ErrorView(
                        error: error,
                        actionLabel: "Retry",
                        action: { Task { await viewModel.shopRepository.loadShops() } }
                    )
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.primaryBackground)
            .navigationTitle("Bloom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    IconButton(icon: "arrow.clockwise") {
                        Task { await viewModel.refreshContent() }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: .vertical)
        .task {
            if case .idle = viewModel.shopRepository.shops {
                await viewModel.loadContent()
            }
        }
        .refreshable {
            await viewModel.refreshContent()
        }
    }
    
    @ViewBuilder
    private var EmptyDiscoverView: some View {
        Text("empty")
    }
    
}

private struct DiscoverContentView: View {

    let shops: [Shop]
    
    var body: some View {
        List {
            if let closestShop = shops.first {
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
                ForEach(shops, id: \.id) { shop in
                    if shop.id != shops.first?.id {
                        NavigationLink (destination: CoffeeShopView(shopId: shop.id)) {
                            ShopListItemView(shop: shop)
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                        .foregroundStyle(Theme.textSecondary)
                    }
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
}
