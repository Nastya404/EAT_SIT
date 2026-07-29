//
//  RestaurantMapView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI
import MapKit

struct RestaurantMapView: View {

    // MARK: - Properties

    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var nearestRestaurant: Restaurant?
    @State private var selectedCategory = "all"

    private let categories = [
        ("all", "home.category.all"),
        ("desserts", "home.category.desserts"),
        ("shawarma", "home.category.shawarma"),
        ("pizza", "home.category.pizza"),
        ("sushi", "home.category.sushi"),
        ("fast_food", "home.category.fastFood"),
        ("asian", "home.category.asian")
    ]

    private var filteredRestaurants: [Restaurant] {

        if selectedCategory == "all" {
            return viewModel.restaurants
        }

        return viewModel.restaurants.filter {
            $0.category == selectedCategory
        }
    }

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 52.2297,
                longitude: 21.0122
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.04,
                longitudeDelta: 0.04
            )
        )
    )

    // MARK: - Body

    var body: some View {

        ZStack(alignment: .bottom) {

            Map(position: $cameraPosition) {

                ForEach(filteredRestaurants) { restaurant in

                    Annotation(
                        restaurant.name,
                        coordinate: CLLocationCoordinate2D(
                            latitude: restaurant.latitude,
                            longitude: restaurant.longitude
                        )
                    ) {

                        NavigationLink {

                            RestaurantView(restaurant: restaurant)

                        } label: {

                            VStack(spacing: 4) {

                                Image(systemName: "fork.knife.circle.fill")
                                    .font(.system(size: 34))
                                    .foregroundStyle(
                                        nearestRestaurant?.id == restaurant.id
                                            ? .green
                                            : .orange
                                    )

                                Text(restaurant.name)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }

            VStack(spacing: 0) {

                categoryFilterView
                bottomPanel
            }
        }
        .navigationTitle("map.title")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Category Filter View

    private var categoryFilterView: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 10) {

                ForEach(categories, id: \.0) { category in

                    Button {

                        selectedCategory = category.0
                        nearestRestaurant = nil
                        moveToNearestRestaurantInSelectedCategory()

                    } label: {

                        Text(LocalizedStringKey(category.1))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                selectedCategory == category.0
                                    ? Color.orange
                                    : Color.white
                            )
                            .foregroundStyle(
                                selectedCategory == category.0
                                    ? .white
                                    : .gray
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(.ultraThinMaterial)
    }

    // MARK: - Bottom Panel

    private var bottomPanel: some View {

        VStack(spacing: 12) {

            if let nearestRestaurant {

                HStack(spacing: 4) {

                    Text("map.nearestRestaurant")
                    Text(nearestRestaurant.name)
                }
                .font(.headline)
                .foregroundStyle(.green)
            }

            Button {

                findNearestRestaurant()

            } label: {

                HStack {

                    Image(systemName: "location.fill")
                    Text("map.findNearestRestaurant")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
    }

    // MARK: - Methods

    private func findNearestRestaurant() {

        locationManager.requestLocation()

        guard let userLocation = locationManager.userLocation else {
            return
        }

        nearestRestaurant = filteredRestaurants.min { first, second in

            let firstLocation = CLLocation(
                latitude: first.latitude,
                longitude: first.longitude
            )

            let secondLocation = CLLocation(
                latitude: second.latitude,
                longitude: second.longitude
            )

            return firstLocation.distance(from: userLocation)
                < secondLocation.distance(from: userLocation)
        }

        if let nearestRestaurant {

            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: nearestRestaurant.latitude,
                        longitude: nearestRestaurant.longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                )
            )
        }
    }

    private func moveToNearestRestaurantInSelectedCategory() {

        guard let restaurant = filteredRestaurants.first else {
            return
        }

        cameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: restaurant.latitude,
                    longitude: restaurant.longitude
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.03,
                    longitudeDelta: 0.03
                )
            )
        )
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        RestaurantMapView()
            .environmentObject(CartViewModel())
            .environmentObject(OrderViewModel())
    }
}
