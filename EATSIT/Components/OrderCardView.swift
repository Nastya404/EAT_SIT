//
//  OrderCardView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct OrderCardView: View {

    // MARK: - Properties

    let order: Order

    private var firstItem: CartItem? {
        order.items.first
    }

    private var orderItemsText: String {
        order.items
            .map { "\($0.quantity)x \($0.dish.name)" }
            .joined(separator: ", ")
    }

    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            mainInfoView
            orderDetailsView
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 5)
    }

    // MARK: - Main Info View

    private var mainInfoView: some View {

        HStack(spacing: 14) {

            orderImageView
            orderTextView

            Spacer()

            priceView
        }
    }

    // MARK: - Order Image View

    private var orderImageView: some View {

        Image(firstItem?.dish.imageName ?? "pizza")
            .resizable()
            .scaledToFill()
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Order Text View

    private var orderTextView: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text(firstItem?.dish.restaurantName ?? String(localized: "order.restaurantFallback"))
                .font(.headline)

            Text(order.createdAt, style: .date)
                .font(.caption)
                .foregroundStyle(.gray)

            statusView
        }
    }

    // MARK: - Price View

    private var priceView: some View {

        VStack(alignment: .trailing, spacing: 6) {

            Text("$\(order.totalPrice, specifier: "%.2f")")
                .font(.title3)
                .fontWeight(.bold)

            Text(
                String(
                    format: String(localized: "order.itemsCount"),
                    order.items.count
                )
            )
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }

    // MARK: - Status View

    private var statusView: some View {

        HStack(spacing: 5) {

            Image(systemName: "checkmark.circle.fill")
                .font(.caption)

            Text("order.delivered")
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundStyle(.green)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.green.opacity(0.12))
        .clipShape(Capsule())
    }

    // MARK: - Order Details View

    private var orderDetailsView: some View {

        Text(orderItemsText)
            .font(.subheadline)
            .foregroundStyle(.gray)
            .lineLimit(2)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Preview

#Preview {

    OrderCardView(
        order: Order(
            items: [],
            deliveryAddress: "Home",
            comment: "",
            paymentMethod: .cash,
            totalPrice: 15.00,
            status: "Delivered",
            createdAt: Date()
        )
    )
}
