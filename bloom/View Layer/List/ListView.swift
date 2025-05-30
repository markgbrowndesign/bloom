//
//  ListView.swift
//  bloom
//
//  Created by Mark Brown on 23/05/2025.
//

import SwiftUI

struct ListView: View {
    
    @StateObject private var viewModel = ShopListViewModel()
    @State private var showingErrorAlert = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.shops.isEmpty {
                    LoaderView(message: "Finding coffee shops")
                } else if viewModel.showEmptyState {
                    EmptyState(
                        title: "No Coffee Shops Found",
                        subtitle: "There were no coffee shops for the criteria you selected",
                        actionTitle: "Retry",
                        action: { viewModel.refreshShops() }
                    )
                } else if let error = viewModel.error {
                    ErrorView(
                        error: error,
                        actionLabel: "Retry",
                        action: { viewModel.refreshShops() }
                    )
                } else {
                    CoffeeShopList
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
                if viewModel.shops.isEmpty {
                    viewModel.loadShops()
                }
            }
            .refreshable {
                viewModel.refreshShops()
            }
        }
    }
    
    var CoffeeShopList: some View {
        List {
            Section {
                ForEach(viewModel.shops, id: \.id) { shop in
                    NavigationLink (destination: CoffeeShopView(shopId: shop.id)) {
                        ShopListItemView(shopName: shop.name, shopLogoSource: "shop_logo_list", shopArea: shop.addressArea)
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
    ListView()
}
