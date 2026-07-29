//
//  PaymentMethod.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation

enum PaymentMethod: String, CaseIterable, Identifiable {

    // MARK: - Cases

    case onlineCard = "Online Card"
    case erip = "ERIP"
    case terminal = "Terminal"
    case cash = "Cash"

    // MARK: - Properties

    var id: String {
        rawValue
    }
}
