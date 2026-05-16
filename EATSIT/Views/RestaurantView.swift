//
//  RestaurantView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct RestaurantView: View {

    // MARK: - Properties

    @StateObject private var viewModel: RestaurantViewModel
    
    let restaurant: Restaurant
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        _viewModel = StateObject(
            wrappedValue: RestaurantViewModel(restaurant: restaurant)
        )
    }

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                restaurantImageView
                restaurantInfoView
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

        ZStack {

            Color.white

            Image(restaurant.imageName)
                .resizable()
                .scaledToFit()
                .padding(28)
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 0))
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


    
    // MARK: - Dishes View

    private var dishesView: some View {

        VStack(spacing: 16) {

            ForEach(viewModel.dishes) { dish in

                NavigationLink {

                    DishDetailsView(dish: dish)

                } label: {

                    DishRowView(dish: dish)
                        .padding(.horizontal, 20)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Basket Button

    private var basketButton: some View {

        NavigationLink {

            BasketView()

        } label: {

            HStack {

                Text("View Basket")

                Spacer()

                Text("Open")
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
