//
//  RestaurantLocation.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 16.05.2026.
//

import Foundation

struct RestaurantLocation: Identifiable {

    // MARK: - Properties

    let id: String

    let restaurantId: String
    let address: String
    let latitude: Double
    let longitude: Double
}
