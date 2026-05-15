//
//  RestaurantView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct RestaurantView: View {

    // MARK: - Properties

    let restaurant: Restaurant

    private let categories = [
        "Pizza",
        "Sushi",
        "Burger",
        "Healthy"
    ]

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                restaurantImageView
                restaurantInfoView
                categoriesView
                dishesView
            }
            .padding(.bottom, 120)
        }
        .background(Color(.systemGray6))
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            basketButton
        }
    }

    // MARK: - Restaurant Image View

    private var restaurantImageView: some View {

        Image(restaurant.imageName)
            .resizable()
            .scaledToFill()
            .frame(height: 260)
            .frame(maxWidth: .infinity)
            .clipped()
    }

    // MARK: - Restaurant Info View

    private var restaurantInfoView: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text(restaurant.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            HStack {

                Image(systemName: "star.fill")
                    .foregroundStyle(.orange)

                Text(String(format: "%.1f", restaurant.rating))
                    .fontWeight(.semibold)

                Text("• \(restaurant.deliveryTime)")
                    .foregroundStyle(.gray)
            }

            Text(restaurant.deliveryPrice)
                .foregroundStyle(.orange)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Categories View

    private var categoriesView: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 12) {

                ForEach(categories, id: \.self) { category in

                    Text(category)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            category == "Pizza"
                            ? Color.orange
                            : Color.white
                        )
                        .foregroundStyle(
                            category == "Pizza"
                            ? .white
                            : .gray
                        )
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Dishes View

    private var dishesView: some View {

        VStack(spacing: 16) {

            ForEach(MockData.dishes) { dish in

                DishRowView(dish: dish)
                    .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Basket Button

    private var basketButton: some View {

        Button {

        } label: {

            HStack {

                Text("View Basket")

                Spacer()

                Text("$34.46")
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding()
            .background(Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .background(.ultraThinMaterial)
        }
    }
}

#Preview {

    NavigationStack {

        RestaurantView(
            restaurant: MockData.restaurants[0]
        )
    }
}
