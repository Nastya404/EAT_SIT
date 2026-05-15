//
//  BasketView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct BasketView: View {

    // MARK: - Properties

    @EnvironmentObject private var cartViewModel: CartViewModel

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                titleView

                if cartViewModel.items.isEmpty {
                    emptyBasketView
                } else {
                    basketItemsView
                    orderSummaryView
                }
            }
            .padding(20)
        }
        .background(Color(.systemGray6))
        .navigationTitle("My Basket")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Title View

    private var titleView: some View {

        Text("\(cartViewModel.items.count) item")
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(Color.orange)
            .clipShape(Capsule())
    }

    // MARK: - Empty Basket View

    private var emptyBasketView: some View {

        Text("Your basket is empty")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity)
            .padding(.top, 80)
    }

    // MARK: - Basket Items View

    private var basketItemsView: some View {

        VStack(spacing: 16) {

            ForEach(cartViewModel.items) { item in

                BasketItemView(item: item)
            }
        }
    }

    // MARK: - Order Summary View

    private var orderSummaryView: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Order Summary")
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                Text("Items Total")
                Spacer()
                Text("$\(cartViewModel.totalPrice, specifier: "%.2f")")
            }

            HStack {
                Text("Delivery Fee")
                Spacer()
                Text("FREE")
                    .foregroundStyle(.green)
                    .fontWeight(.bold)
            }

            Divider()

            HStack {
                Text("Total to Pay")
                    .font(.title3)
                    .fontWeight(.bold)

                Spacer()

                Text("$\(cartViewModel.totalPrice, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        BasketView()
            .environmentObject(CartViewModel())
    }
}
