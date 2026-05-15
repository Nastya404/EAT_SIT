//
//  RestaurantCardView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct RestaurantCardView: View {

    // MARK: - Properties

    let restaurant: Restaurant

    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            restaurantImageView
            restaurantInfoView
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .frame(maxWidth: .infinity)
    }

    // MARK: - Restaurant Image View

    private var restaurantImageView: some View {

        ZStack(alignment: .topLeading) {

            Image(restaurant.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipped()

            if restaurant.isPopular {

                Text("POPULAR")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.orange)
                    .clipShape(Capsule())
                    .padding(10)
            }
        }
    }

    // MARK: - Restaurant Info View

    private var restaurantInfoView: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text(restaurant.name)
                .font(.headline)

            ratingView

            Text(restaurant.deliveryPrice)
                .font(.caption)
                .foregroundStyle(.orange)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.orange.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
    }

    // MARK: - Rating View

    private var ratingView: some View {

        HStack(spacing: 4) {

            Image(systemName: "star.fill")
                .foregroundStyle(.orange)
                .font(.caption)

            Text(String(format: "%.1f", restaurant.rating))
                .fontWeight(.semibold)

            Text("•")

            Text(restaurant.deliveryTime)
                .foregroundStyle(.gray)
        }
        .font(.subheadline)
    }
}

// MARK: - Preview

#Preview {

    RestaurantCardView(
        restaurant: MockData.restaurants[0]
    )
}
