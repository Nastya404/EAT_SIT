//
//  MockData.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation

struct MockData {

    // MARK: - Restaurants Mock Data

    static let restaurants: [Restaurant] = [

        Restaurant(
            name: "Pizza Palace",
            imageName: "pizza",
            rating: 4.8,
            deliveryTime: "20-30 min",
            deliveryPrice: "Free Delivery",
            isPopular: false
        ),

        Restaurant(
            name: "Sakura Sushi Bar",
            imageName: "sushi",
            rating: 4.9,
            deliveryTime: "25-35 min",
            deliveryPrice: "$1.99 Delivery",
            isPopular: false
        ),

        Restaurant(
            name: "Burger House",
            imageName: "burger",
            rating: 4.7,
            deliveryTime: "15-25 min",
            deliveryPrice: "Free Delivery",
            isPopular: true
        ),

        Restaurant(
            name: "The Green Bowl",
            imageName: "salad",
            rating: 4.6,
            deliveryTime: "20-30 min",
            deliveryPrice: "$0.99 Delivery",
            isPopular: false
        ),

        Restaurant(
            name: "Pasta Roma",
            imageName: "pasta",
            rating: 4.5,
            deliveryTime: "30-40 min",
            deliveryPrice: "Free Delivery",
            isPopular: false
        ),

        Restaurant(
            name: "Dessert Cloud",
            imageName: "dessert",
            rating: 4.9,
            deliveryTime: "20-25 min",
            deliveryPrice: "$1.49 Delivery",
            isPopular: true
        )
    ]
}
