//
//  OrderViewModel.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI
import Combine

final class OrderViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var orders: [Order] = []

    // MARK: - Initialization

    init() {
        loadOrders()
    }

    // MARK: - Methods

    func loadOrders() {
        orders = DatabaseManager.shared.fetchOrders()
    }

    func addOrder(_ order: Order) {
        DatabaseManager.shared.insertOrder(order)
        loadOrders()
    }
}
