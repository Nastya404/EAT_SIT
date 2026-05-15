//
//  Dish.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation

struct Dish: Identifiable {

    // MARK: - Properties

    let id = UUID()

    let name: String
    let description: String
    let price: Double
    let imageName: String
    let category: String
    let restaurantName: String
}
