//
//  RestaurantViewModel.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation
import Combine

final class RestaurantViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var dishes: [Dish] = []

    // MARK: - Properties

    private let restaurant: Restaurant

    // MARK: - Initialization

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        loadDishes()
    }

    // MARK: - Methods

    func loadDishes() {
        dishes = DatabaseManager.shared.fetchDishes(for: restaurant)
    }
}
