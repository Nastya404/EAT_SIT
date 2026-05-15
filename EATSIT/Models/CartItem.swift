//
//  CartItem.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation

struct CartItem: Identifiable {

    // MARK: - Properties

    let id = UUID()

    let dish: Dish
    let quantity: Int
    let selectedToppings: [DishCustomization]

    var totalPrice: Double {

        let toppingsPrice = selectedToppings.reduce(0) {
            $0 + $1.price
        }

        return (dish.price + toppingsPrice) * Double(quantity)
    }
}
