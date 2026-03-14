//
//  ShopListView.swift
//  bloom
//
//  Created by Mark Brown on 23/05/2025.
//

import SwiftUI

struct ShopListView: View {
    
    @State private var viewModel: ShopListViewModel
    
    init(shopService: ShopService) {
        self._viewModel = State(wrappedValue: ShopListViewModel(shopService: shopService))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    LoaderView(message: "Finding nearby coffee shops")
                } else if let error = viewModel.error {
                    ErrorView(
                        error: error,
                        actionLabel: "Retry",
                        action: { Task { await viewModel.refreshShops() } }
                    )
                } else if viewModel.shops.isEmpty {
                    EmptyState(
                        title: "No Coffee Shops Found",
                        subtitle: "There were no coffee shops for the criteria you selected",
                        actionTitle: "Retry",
                        action: { Task { await viewModel.refreshShops() } }
                    )
                } else {
                    CoffeeShopList(shops: viewModel.shops)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .scrollContentBackground(.hidden)
            .background(Theme.primaryBackground)
            .navigationTitle("All shops")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: Present filter sheet
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }
            }
            .task {
                await viewModel.loadShops()
            }
            .refreshable {
                await viewModel.refreshShops()
            }
        }
    }
}

struct CoffeeShopList: View {
    
    let shops: [Shop]
    
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
                VStack(alignment: .center, spacing: 8) {
                    Text("Are we missing somewhere?")
                        .foregroundStyle(Theme.textSecondary)
                    
                    textButton(title: "Recommend a coffee shop") { }
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textButton)
                }
                .frame(maxWidth: .infinity)
            }
            .listRowBackground(Color.clear)
        }
        .contentMargins(.top, 16)
        .listSectionSpacing(16)
    }
}

#Preview {
    ShopListView(shopService: ShopService())
}
