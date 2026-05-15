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
    
    
    // MARK: - Dishes Mock Data

    static let dishes: [Dish] = [

        Dish(
            name: "Pepperoni Pizza",
            description: "Classic pepperoni pizza with mozzarella cheese",
            price: 12.99,
            imageName: "pizza",
            category: "Pizza"
        ),

        Dish(
            name: "California Roll",
            description: "Crab meat, avocado and cucumber",
            price: 9.99,
            imageName: "sushi",
            category: "Sushi"
        ),

        Dish(
            name: "Cheese Burger",
            description: "Beef burger with cheddar cheese",
            price: 10.49,
            imageName: "burger",
            category: "Burger"
        ),

        Dish(
            name: "Caesar Salad",
            description: "Fresh salad with parmesan and chicken",
            price: 8.99,
            imageName: "salad",
            category: "Healthy"
        )
    ]
    
    // MARK: - Dish Customizations Mock Data

    static let customizations: [DishCustomization] = [

        DishCustomization(
            name: "Extra Cheese",
            price: 1.00
        ),

        DishCustomization(
            name: "Jalapeños",
            price: 0.50
        ),

        DishCustomization(
            name: "Bacon",
            price: 2.00
        )
    ]
}
