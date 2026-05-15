//
//  CartViewModel.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//
//
//  CartViewModel.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI
import Combine

final class CartViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var items: [CartItem] = []

    // MARK: - Computed Properties

    var totalPrice: Double {

        items.reduce(0) { $0 + $1.totalPrice }
    }

    // MARK: - Methods

    func addItem(_ item: CartItem) {

        items.append(item)
    }

    func removeItem(_ item: CartItem) {

        items.removeAll { $0.id == item.id }
    }

    func clearCart() {

        items.removeAll()
    }
}
