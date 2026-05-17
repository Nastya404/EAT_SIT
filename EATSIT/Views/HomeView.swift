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
    @EnvironmentObject private var localizationManager: LocalizationManager
    @State private var selectedCategory = "all"
    @State private var searchText = ""
    @State private var selectedDeliveryAddress = "home.address"
    @State private var showAddressPicker = false

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

        let categoryFilteredRestaurants = selectedCategory == "all"
            ? viewModel.restaurants
            : viewModel.restaurants.filter {
                $0.category == selectedCategory
            }

        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return categoryFilteredRestaurants
        }

        return categoryFilteredRestaurants.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
                || $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
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
            .sheet(isPresented: $showAddressPicker) {

                VStack(spacing: 24) {

                    Text("home.selectAddress")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)

                    addressButton(
                        titleKey: "home.address",
                        value: "home.address"
                    )

                    addressButton(
                        titleKey: "checkout.address.office",
                        value: "checkout.address.office"
                    )

                    addressButton(
                        titleKey: "home.currentLocation",
                        value: "home.currentLocation"
                    )

                    Spacer()
                }
                .padding()
                .presentationDetents([.height(320)])
            }
            .onChange(of: localizationManager.selectedLanguage) {
                viewModel.loadRestaurants()
            }
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

                Button {

                    showAddressPicker = true

                } label: {

                    HStack(spacing: 6) {

                        Text(LocalizedStringKey(selectedDeliveryAddress))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)

                        Image(systemName: "chevron.down")
                            .foregroundStyle(.orange)
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                HStack(spacing: 12) {

                    NavigationLink {

                        RestaurantMapView()

                    } label: {

                        Image(systemName: "globe.europe.africa.fill")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.orange)
                            .clipShape(Circle())
                    }

                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.orange)
                }
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

            TextField("home.search", text: $searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if !searchText.isEmpty {

                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }

            Button {

                selectedCategory = "all"
                searchText = ""

            } label: {

                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Categories View

    private var categoriesView: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 14) {

                ForEach(categories, id: \.0) { category in

                    Button {

                        selectedCategory = category.0

                    } label: {

                        Text(LocalizedStringKey(category.1))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
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
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)
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

            if filteredRestaurants.isEmpty {

                Text("home.noRestaurantsFound")
                    .font(.headline)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)

            } else {

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 18),
                        GridItem(.flexible(), spacing: 18)
                    ],
                    spacing: 22
                ) {

                    ForEach(filteredRestaurants) { restaurant in
                        
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

    // MARK: - Address Button

    private func addressButton(
        titleKey: String,
        value: String
    ) -> some View {

        Button {

            selectedDeliveryAddress = value
            showAddressPicker = false

        } label: {

            Text(LocalizedStringKey(titleKey))
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}

// MARK: - Preview

#Preview {

    HomeView()
}
