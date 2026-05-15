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

    // MARK: - Methods

    func addOrder(_ order: Order) {

        orders.insert(order, at: 0)
    }
}
