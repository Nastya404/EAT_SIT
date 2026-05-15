//
//  HomeView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct HomeView: View {

    // MARK: - Properties

    private let categories = [
        "🍕 Pizza",
        "🍣 Sushi",
        "🍔 Burgers",
        "🥗 Healthy",
        "🍰 Desserts"
    ]

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 24) {

                    headerView
                    searchView
                    categoriesView
                    restaurantsView
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
            .background(Color(.systemGray6))
        }
    }

    // MARK: - Header View

    private var headerView: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text("DELIVERING TO")
                .font(.caption)
                .foregroundStyle(.gray)

            HStack {

                Image(systemName: "location.fill")
                    .foregroundStyle(.orange)

                Text("Home")
                    .font(.title3)
                    .fontWeight(.bold)

                Image(systemName: "chevron.down")
                    .foregroundStyle(.orange)

                Spacer()

                Image(systemName: "person.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(.orange)
            }

            Text("What are you craving today? 🍔")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 16)
        }
    }

    // MARK: - Search View

    private var searchView: some View {

        HStack {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)

            Text("Search for restaurants or dishes")
                .foregroundStyle(.gray.opacity(0.7))

            Spacer()

            Image(systemName: "slider.horizontal.3")
                .foregroundStyle(.white)
                .padding(10)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Categories View

    private var categoriesView: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 14) {

                ForEach(categories, id: \.self) { category in

                    Text(category)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            category.contains("Pizza")
                            ? Color.orange
                            : Color.white
                        )
                        .foregroundStyle(
                            category.contains("Pizza")
                            ? .white
                            : .gray
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
        }
    }

    // MARK: - Restaurants View

    private var restaurantsView: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                Text("🔥 Popular Near You")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Text("See all")
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
            }

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 18),
                    GridItem(.flexible(), spacing: 18)
                ],
                spacing: 22
            ) {

                ForEach(MockData.restaurants) { restaurant in

                    NavigationLink {

                        RestaurantView(
                            restaurant: restaurant
                        )

                    } label: {

                        RestaurantCardView(
                            restaurant: restaurant
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {

    HomeView()
}
