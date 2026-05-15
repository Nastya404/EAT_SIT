//
//  BasketItemView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct BasketItemView: View {

    // MARK: - Properties

    let item: CartItem

    // MARK: - Body

    var body: some View {

        HStack(spacing: 14) {

            dishImageView
            dishInfoView

            Spacer()

            priceView
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    // MARK: - Dish Image View

    private var dishImageView: some View {

        Image(item.dish.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 76, height: 76)
            .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - Dish Info View

    private var dishInfoView: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text(item.dish.name)
                .font(.headline)

            Text("Quantity: \(item.quantity)")
                .font(.subheadline)
                .foregroundStyle(.gray)

            if !item.selectedToppings.isEmpty {

                Text(
                    item.selectedToppings
                        .map { $0.name }
                        .joined(separator: ", ")
                )
                .font(.caption)
                .foregroundStyle(.gray)
                .lineLimit(2)
            }
        }
    }

    // MARK: - Price View

    private var priceView: some View {

        Text("$\(item.totalPrice, specifier: "%.2f")")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(.orange)
    }
}
