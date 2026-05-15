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
            category: "Pizza",
            restaurantName: "Pizza Palace"
        ),

        Dish(
            name: "Margherita Pizza",
            description: "San Marzano tomatoes and mozzarella",
            price: 14.00,
            imageName: "pizza",
            category: "Pizza",
            restaurantName: "Pizza Palace"
        ),

        Dish(
            name: "California Roll",
            description: "Crab meat, avocado and cucumber",
            price: 9.99,
            imageName: "sushi",
            category: "Sushi",
            restaurantName: "Sakura Sushi Bar"
        ),

        Dish(
            name: "Salmon Nigiri",
            description: "Fresh salmon with sushi rice",
            price: 11.50,
            imageName: "sushi",
            category: "Sushi",
            restaurantName: "Sakura Sushi Bar"
        ),

        Dish(
            name: "Cheese Burger",
            description: "Beef burger with cheddar cheese",
            price: 10.49,
            imageName: "burger",
            category: "Burger",
            restaurantName: "Burger House"
        ),

        Dish(
            name: "Smoky Wagyu Burger",
            description: "Juicy beef patty, smoked cheddar and brioche bun",
            price: 12.00,
            imageName: "burger",
            category: "Burger",
            restaurantName: "Burger House"
        ),

        Dish(
            name: "Caesar Salad",
            description: "Fresh salad with parmesan and chicken",
            price: 8.99,
            imageName: "salad",
            category: "Healthy",
            restaurantName: "The Green Bowl"
        ),

        Dish(
            name: "Green Bowl",
            description: "Vegetables, grains and light dressing",
            price: 9.50,
            imageName: "salad",
            category: "Healthy",
            restaurantName: "The Green Bowl"
        ),

        Dish(
            name: "Pasta Carbonara",
            description: "Pasta with parmesan and creamy sauce",
            price: 13.50,
            imageName: "pasta",
            category: "Pasta",
            restaurantName: "Pasta Roma"
        ),

        Dish(
            name: "Lemon Tart",
            description: "French pastry with lemon cream",
            price: 7.50,
            imageName: "dessert",
            category: "Dessert",
            restaurantName: "Dessert Cloud"
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
    
    static let profileOptions: [ProfileOption] = [

        ProfileOption(
            title: "Payment Methods",
            iconName: "creditcard.fill"
        ),

        ProfileOption(
            title: "Delivery Addresses",
            iconName: "location.fill"
        ),

        ProfileOption(
            title: "Notifications",
            iconName: "bell.fill"
        ),

        ProfileOption(
            title: "Language",
            iconName: "globe"
        ),

        ProfileOption(
            title: "Help & Support",
            iconName: "questionmark.circle.fill"
        )
    ]
}
