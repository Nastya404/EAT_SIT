//
//  Restaurant.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation

struct Restaurant: Identifiable {
    let id = UUID()
    
    let name: String
    let category: String
    let rating: Double
    let deliveryTime: String
    let deliveryPrice: String
    let imageName: String
    let isPopular: Bool
}
