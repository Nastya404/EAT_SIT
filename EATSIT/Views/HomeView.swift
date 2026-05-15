//
//  HomeView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct HomeView: View {

    // MARK: - Properties
    
    @StateObject private var viewModel = HomeViewModel()

    private let categories = [
        "home.category.pizza",
        "home.category.sushi",
        "home.category.burgers",
        "home.category.healthy",
        "home.category.desserts"
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

            Text("home.deliveringTo")
                .font(.caption)
                .foregroundStyle(.gray)

            HStack {

                Image(systemName: "location.fill")
                    .foregroundStyle(.orange)

                Text("home.address")
                    .font(.title3)
                    .fontWeight(.bold)

                Image(systemName: "chevron.down")
                    .foregroundStyle(.orange)

                Spacer()

                Image(systemName: "person.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(.orange)
            }

            Text("home.question")
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

            Text("home.search")
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

                    Text(LocalizedStringKey(category))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            category == "home.category.pizza"
                            ? Color.orange
                            : Color.white
                        )
                        .foregroundStyle(
                            category == "home.category.pizza"
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

                Text("home.popularNearYou")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Text("home.seeAll")
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

                ForEach(viewModel.restaurants) { restaurant in

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
