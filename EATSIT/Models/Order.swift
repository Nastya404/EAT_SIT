//
//  Order.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation

struct Order: Identifiable {

    // MARK: - Properties

    let id = UUID()

    let items: [CartItem]
    let deliveryAddress: String
    let comment: String
    let paymentMethod: PaymentMethod
    let totalPrice: Double
    let status: String
    let createdAt: Date
}
