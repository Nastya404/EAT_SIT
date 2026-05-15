//
//  RestaurantCardView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct RestaurantCardView: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(Color.orange.opacity(0.25))
                .frame(height: 120)
                .overlay(
                    Text(restaurant.category)
                        .font(.headline)
                        .foregroundStyle(.orange)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(restaurant.name)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.orange)
                    Text(String(format: "%.1f", restaurant.rating))
                        .foregroundStyle(.orange)
                    Text("• \(restaurant.deliveryTime)")
                        .foregroundStyle(.gray)
                }
                .font(.subheadline)
                
                Text(restaurant.deliveryPrice)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

#Preview {
    RestaurantCardView(restaurant: MockData.restaurants[0])
        .padding()
}
