//
//  HomeViewModel.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var restaurants: [Restaurant] = []

    // MARK: - Initialization

    init() {
        loadRestaurants()
    }

    // MARK: - Methods

    func loadRestaurants() {
        restaurants = DatabaseManager.shared.fetchRestaurants()
    }
}
