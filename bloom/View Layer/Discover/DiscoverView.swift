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
       _viewModel = State(wrappedValue: DiscoverViewModel(shopService: shopService))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    LoaderView(message: "Finding coffee...")
                } else if let error = viewModel.error {
                    ErrorView(
                        error: error,
                        actionLabel: "Retry",
                        action: { Task { await viewModel.refreshContent() } }
                    )
                } else if viewModel.hasShops {
                    DiscoverContentView (
                        shopService: viewModel.shopService,
                        closestShop: viewModel.closestShop,
                        nearbyShops: viewModel.nearbyShops
                    )
                } else {
                    EmptyState(
                        title: "No Coffee Shops Found",
                        subtitle: "There were no coffee shops for the criteria you selected",
                        actionTitle: "Retry",
                        action: { Task { await viewModel.refreshContent() } }
                    )
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.primaryBackground)
            .navigationTitle("Bloom")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await viewModel.refreshContent() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: .vertical)
        .task {
            await viewModel.loadContent()
        }
        .refreshable {
            await viewModel.refreshContent()
        }
    }
}

private struct DiscoverContentView: View {

    let shopService: ShopService
    let closestShop: Shop?
    let nearbyShops: [Shop]
    
    var body: some View {
        List {
            if let closestShop {
                Section {
                    ZStack(alignment: .leading) {
                        NavigationLink (destination: CoffeeShopView(shopId: closestShop.id, shopService: shopService)) {
                            EmptyView()
                        }
                        .opacity(0)
                        ShopListItemLargeView(shop: closestShop)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .foregroundStyle(Theme.textSecondary)
                } header: {
                    Text("Closest")
                        .font(.title2)
                        .textCase(.none)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                        .foregroundStyle(Theme.textSecondary)
                }
                .listRowBackground(Theme.sectionBackground)
                .listRowSeparatorTint(Theme.textPrimary.opacity(0.25))

            }
            Section {
                ForEach(nearbyShops, id: \.id) { shop in
                    NavigationLink (destination: CoffeeShopView( shopId: shop.id, shopService: shopService)) {
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
}
