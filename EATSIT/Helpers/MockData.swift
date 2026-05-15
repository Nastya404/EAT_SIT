//
//  MockData.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation

struct MockData {
    
    static let restaurants = [
        Restaurant(
            name: "Pizza Palace",
            category: "Pizza",
            rating: 4.8,
            deliveryTime: "20-30 min",
            deliveryPrice: "Free Delivery",
            imageName: "pizza",
            isPopular: true
        ),
        
        Restaurant(
            name: "Sakura Sushi Bar",
            category: "Sushi",
            rating: 4.9,
            deliveryTime: "25-35 min",
            deliveryPrice: "$1.99 Delivery",
            imageName: "sushi",
            isPopular: false
        ),
        
        Restaurant(
            name: "Burger House",
            category: "Burgers",
            rating: 4.7,
            deliveryTime: "15-25 min",
            deliveryPrice: "Free Delivery",
            imageName: "burger",
            isPopular: true
        )
    ]
}
