//
//  CoffeeShopView.swift
//  bloom
//
//  Created by Mark Brown on 11/05/2025.
//

import SwiftUI
import Supabase
import MapKit

struct CoffeeShopView: View {
    
    let shopId: UUID
    
    @EnvironmentObject var shopReposiory: ShopRepository
    
    @StateObject private var viewModel = CoffeeShopViewModel()
    @State private var showingErrorAlert = false
    
    @State private var showFullDescription = false
    
    init(shopId: UUID) {
        self.shopId = shopId
    }

    var body: some View {
        NavigationStack{
            Group {
                if viewModel.isLoading {
                    LoaderView(message: "Loading shop details...")
                } else if viewModel.shop != nil {
                    ShopDetailContent
                } else if viewModel.error != nil {
                    EmptyState(
                        title: "Failed to Load",
                        subtitle: "We couldn't load the details for this coffee shop. Please check your connection and try again.",
                        actionTitle: "Retry",
                        action: { viewModel.loadShop(shopId: shopId, forceRefresh: true) }
                    )
                    .frame(maxHeight: .infinity)
                }
            }
            .task {
                viewModel.loadShop(shopId: shopId)
            }
            .onAppear {
                viewModel.setupDependencies(shopRepository: shopReposiory)
            }
            .ignoresSafeArea(.container, edges: .vertical)
            .background(Theme.primaryBackground)
        }
    }
    
    var ShopDetailContent: some View {
            ScrollView {
                if let shop = viewModel.shop {
                    VStack (spacing: 0) {
                        HeaderView(headerImage: "coffee_shop_background", logoImage: "shop_logo")
                        VStack(spacing: 24) {
                            TitleView(shop: shop)
                            ButtonsGroupView(onDirectionsTap: { viewModel.onTapDirections() }, onNoteTap: {}, onFavoriteTap: {}, onUpvoteTap: {})
                            if shop.details.longDescription != nil {
                                TruncatableText(text: shop.details.longDescription ?? "")
                            }
                            CafeDetailsView(shop: shop.details)
                            BottomText(shop: shop.details)
                        }
                        .padding(.bottom, 120)
                    }
                }
            }
            .coordinateSpace(name: "scroll")
    }
}

struct HeaderView: View {
    
    let headerImage: String
    let logoImage: String
    let height: CGFloat = 375
    
    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("scroll")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            ZStack(alignment: .top) {
                // Background image
                Image(headerImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: height > 0 ? height : 0, alignment: .bottom)
                
                // Gradient and logo overlay
                ZStack(alignment: .bottom) {
                    LinearGradient(colors: [
                        Theme.primaryBackground.opacity(0),
                        Theme.primaryBackground.opacity(1)
                    ], startPoint: .top, endPoint: .bottom)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Image(logoImage)
                            .resizable()
                            .frame(width: 160, height: 160, alignment: .bottom)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(width: size.width, height: height > 0 ? height : 0, alignment: .bottom)
            }
            .offset(y: -minY)
        }
        .frame(height: height)
    }
}

struct TitleView: View {
    
    let shop: Shop
    
    var body: some View {
        VStack {
            Text(shop.details.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .padding(.bottom, 4)
            
            HStack(spacing: 4) {
                //TODO: add if viewModel.isLoading
                Text(shop.details.addressArea)
                Text("•")
                Text(formatDistance(shop.distance ?? 1.2) + " away")
            }
            .foregroundStyle(Theme.textSecondary)
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity)
    }
    func formatDistance(_ distance: Double, unit: MeaurementUnit = .metric) -> String {
        switch unit {
        case .metric:
         let km = distance / 1000.0
         return km < 10 ? String(format: "%.1fkm", km) : String(format: "%.0fkm", km)
        case .imperial:
         let formatter = MeasurementFormatter()
         formatter.unitOptions = .naturalScale
         formatter.numberFormatter.maximumFractionDigits = 1
         formatter.locale = Locale(identifier: "en_US") // Force imperial
         
         let meters = Measurement(value: distance, unit: UnitLength.meters)
         return formatter.string(from: meters)
        }
    }
}

struct ButtonsGroupView: View {
    let onDirectionsTap: () -> Void
    let onNoteTap: () -> Void
    let onFavoriteTap: () -> Void
    let onUpvoteTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            
            // Main action button
            primaryButton(title: "Get directions", action: onDirectionsTap)

            // Quick action buttons row
            HStack(spacing: 8) {
                actionButton(icon: "note.text", title: "Private note", action: onNoteTap)
                actionButton(icon: "plus", title: "Favourite", action: onFavoriteTap)
                actionButton(icon: "hand.thumbsup", title: "Up vote", action: onUpvoteTap)
            }
            .foregroundColor(Theme.textSecondary)
        }
        .padding(.horizontal)
    }
}

struct AddressView: View {
    
    let shopLatitude: Double
    let shopLongitude: Double
    
    @State private var region = MKCoordinateRegion()
    
    let addressLine1: String
    let addressLine2: String
    
    var body: some View {
        VStack() {
            MapView(region: $region)
                .frame(height: 200)
            
            VStack(spacing: 4){
                Text(addressLine1)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(addressLine2)
                    .foregroundStyle(Theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
        }
        .background(Theme.sectionBackground)
        .clipShape(.rect(cornerRadius: Layout.cornerRadius))
        .task {
            region.center = CLLocationCoordinate2D(latitude: shopLatitude, longitude: shopLongitude)
            region.span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        }
    }
}

struct CafeDetailsView: View {
    var shop: ShopDetail
    
    var body: some View {
        
        VStack(spacing: 16) {
            Section {
                AddressView(shopLatitude: shop.coordinatesLatitude ?? 0, shopLongitude: shop.coordinatesLongitude ?? 0, addressLine1: shop.addressFirstLine ?? "", addressLine2: shop.addressSecondLine ?? "")
            }
            Section {
                //Coffee served
                DetailSection(title: "Coffee") {
                    DetailTextRow(label: shop.coffeeServed ?? "Unknown", value: "")
                }
                
                DetailSection(title: "Equipment") {
                    DetailTextRow(label: "Espresso machine", value: shop.equipmentMachine ?? "Unknown")
                    DetailTextRow(label: "Grinder", value: shop.equipmentGrinder ?? "Unknown")
                }
                
//                DetailSection(title: "Serving") {
//                    DetailIconRow(label: "Espresso", value: true)
//                    DetailIconRow(label: "Pour over", value: false)
//                    DetailIconRow(label: "Syphon", value: false)
//                    DetailIconRow(label: "Matcha", value: true)
//                }
                
                DetailSection(title: "Ammenities") {
                    DetailIconRow(label: "Accessible", value: shop.serviceAccessible ?? false)
                    DetailIconRow(label: "Serves food", value: shop.serviceFoodHot ?? false)
                    DetailIconRow(label: "WiFi", value: shop.serviceWiFi ?? false)
                    DetailIconRow(label: "Sells coffee beans", value: shop.serviceSellsBeans ?? false)
                    DetailIconRow(label: "Pet friendly", value: shop.servicePetFriendly ?? false)
                }
                
            } header: {
                Text("All details")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
        .foregroundStyle(Theme.textSecondary)
        .padding(.horizontal)
        
    }
}

struct BottomText: View {
    
    let shop: ShopDetail
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Last updated: \(shop.lastUpdatedAt)")
                .foregroundStyle(Theme.textSecondary)
            
            textButton(title: "Report inaccuracies") { }
                .fontWeight(.bold)
                .foregroundStyle(Theme.textButton)
        }
        
    }
}

struct DetailSection<Content: View>: View {
    
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
                .frame(height: 4)
            content
        }
        .padding(16)
        .background(Theme.sectionBackground)
        .clipShape(.rect(cornerRadius: Layout.cornerRadius))
    }
    
}

struct DetailTextRow: View {

    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .foregroundStyle(Theme.textSecondary)
            Spacer()
            Text(value)
                .foregroundStyle(Theme.textPrimary)
        }
    }
}

struct DetailIconRow: View {

    let label: String
    let value: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .foregroundStyle(Theme.textSecondary)
            Spacer()
            Image(systemName: value ? "checkmark" : "xmark")
                .foregroundStyle(value ? Theme.textPrimary : Theme.textSecondary)
        }
    }
}

struct TruncatableText: View {
    let text: String
    @State private var isExpanded = false
    let lineLimit: Int = 3
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(text)
                .lineLimit(isExpanded ? nil : lineLimit)
                .foregroundStyle(Theme.textSecondary)
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text(isExpanded ? "See less" : "Continue reading")
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.textButton)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

struct MapView: UIViewRepresentable {
    
    @Binding var region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = .mutedStandard
        mapView.isRotateEnabled = false
        mapView.showsCompass = false
        mapView.isUserInteractionEnabled = false
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
        
        // Add annotation for the location
        let annotation = MKPointAnnotation()
        annotation.coordinate = region.center
        mapView.addAnnotation(annotation)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Location"
            
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                return annotationView
            } else {
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.markerTintColor = .systemRed
                return annotationView
            }
        }
    }
}

struct CoffeeShopDetailViewAlt_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeShopView(shopId: UUID(uuidString: "1234")!)
    }
}
