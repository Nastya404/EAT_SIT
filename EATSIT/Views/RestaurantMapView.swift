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
                                .foregroundStyle(.orange)

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
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
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
