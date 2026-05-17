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
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {

        ZStack(alignment: .bottom) {

            ScrollView {

                VStack(alignment: .leading, spacing: 26) {

                    headerView

                    if cartViewModel.items.isEmpty {
                        emptyBasketView
                    } else {
                        orderSectionView
                        orderSummaryView
                        deliveryInfoView
                    }
                }
                .padding(20)
                .padding(.bottom, 110)
            }
            .background(Color(.systemGray6))

            if !cartViewModel.items.isEmpty {
                checkoutButton
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Header View

    private var headerView: some View {

        HStack {

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(width: 52, height: 52)
                    .background(Color.white)
                    .clipShape(Circle())
            }

            Spacer()

            Text("basket.title")
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            Text(
                String(
                    format: String(localized: "basket.itemsCount"),
                    cartViewModel.items.count
                )
            )
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Order Section View

    private var orderSectionView: some View {

        VStack(alignment: .leading, spacing: 18) {

            Text("basket.yourOrder")
                .font(.headline)
                .foregroundStyle(.gray)

            VStack(spacing: 16) {

                ForEach(cartViewModel.items) { item in

                    BasketItemView(item: item)
                }
            }
        }
    }

    // MARK: - Empty Basket View

    private var emptyBasketView: some View {

        Text("basket.empty")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity)
            .padding(.top, 80)
    }

    // MARK: - Order Summary View

    private var orderSummaryView: some View {

        VStack(alignment: .leading, spacing: 18) {

            Text("basket.summary")
                .font(.headline)
                .foregroundStyle(.gray)

            VStack(spacing: 18) {

                summaryRow(
                    icon: "list.clipboard",
                    title: String(localized: "basket.itemsTotal"),
                    value: String(format: "$%.2f", cartViewModel.totalPrice)
                )

                Divider()

                HStack {

                    Label("basket.deliveryFee", systemImage: "scooter")
                        .foregroundStyle(.gray)

                    Spacer()

                    Text("$2.99")
                        .strikethrough()
                        .foregroundStyle(.gray.opacity(0.6))

                    Text("basket.freeDelivery")
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Divider()

                summaryRow(
                    icon: "banknote",
                    title: String(localized: "basket.totalToPay"),
                    value: String(format: "$%.2f", cartViewModel.totalPrice),
                    isTotal: true
                )
            }
            .padding(20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 26))
        }
    }

    // MARK: - Delivery Info View

    private var deliveryInfoView: some View {

        HStack(spacing: 12) {

            Image(systemName: "truck.box")
                .foregroundStyle(.orange)

            Text("basket.deliveryInfo")
                .font(.headline)
                .foregroundStyle(.orange)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.08))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.orange.opacity(0.25))
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - Checkout Button

    private var checkoutButton: some View {

        NavigationLink {

            CheckoutView()

        } label: {

            HStack {

                Image(systemName: "lock.fill")

                Text(
                    String(localized: "basket.checkout") +
                    String(format: " — $%.2f", cartViewModel.totalPrice)
                )

                Image(systemName: "chevron.right")
            }
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(20)
            .background(Color.white)
        }
    }

    // MARK: - Helper Views

    private func summaryRow(
        icon: String,
        title: String,
        value: String,
        isTotal: Bool = false
    ) -> some View {

        HStack {

            Label(title, systemImage: icon)
                .font(isTotal ? .title3 : .body)
                .fontWeight(isTotal ? .bold : .regular)

            Spacer()

            Text(value)
                .font(isTotal ? .title2 : .body)
                .fontWeight(.bold)
                .foregroundStyle(isTotal ? .orange : .primary)
        }
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        BasketView()
            .environmentObject(CartViewModel())
    }
}
