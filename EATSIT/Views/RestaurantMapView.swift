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

                ForEach(viewModel.restaurants) { restaurant in

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

            bottomPanel
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Bottom Panel

    private var bottomPanel: some View {

        VStack(spacing: 12) {

            if let nearestRestaurant {

                Text("Nearest restaurant: \(nearestRestaurant.name)")
                    .font(.headline)
                    .foregroundStyle(.green)
            }

            Button {

                findNearestRestaurant()

            } label: {

                HStack {

                    Image(systemName: "location.fill")
                    Text("Find nearest restaurant")
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

        nearestRestaurant = viewModel.restaurants.min { first, second in

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
}

// MARK: - Preview

#Preview {

    NavigationStack {

        RestaurantMapView()
            .environmentObject(CartViewModel())
            .environmentObject(OrderViewModel())
    }
}
