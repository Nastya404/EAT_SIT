//
//  Restaurant.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation

struct Restaurant: Identifiable {

    // MARK: - Properties

    let id = UUID()

    let name: String
    let imageName: String
    let rating: Double
    let deliveryTime: String
    let deliveryPrice: String
    let isPopular: Bool
}
