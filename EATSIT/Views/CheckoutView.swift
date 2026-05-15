//
//  CheckoutView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//


import SwiftUI

struct CheckoutView: View {

    // MARK: - Properties

    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var orderViewModel: OrderViewModel

    @State private var deliveryAddress = ""
    @State private var orderComment = ""
    @State private var selectedPaymentMethod: PaymentMethod = .cash
    @State private var showSuccessAlert = false

    private var isOrderButtonDisabled: Bool {
        deliveryAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || cartViewModel.items.isEmpty
    }

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                orderItemsView
                addressView
                commentView
                paymentMethodView
                totalView
                confirmOrderButton
            }
            .padding(20)
        }
        .background(Color(.systemGray6))
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Order successfully placed", isPresented: $showSuccessAlert) {
            Button("OK") {
                cartViewModel.clearCart()
            }
        }
    }

    // MARK: - Order Items View

    private var orderItemsView: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Order Items")
                .font(.title2)
                .fontWeight(.bold)

            ForEach(cartViewModel.items) { item in

                BasketItemView(item: item)
            }
        }
    }

    // MARK: - Address View

    private var addressView: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Delivery Address")
                .font(.title2)
                .fontWeight(.bold)

            TextField("Enter delivery address", text: $deliveryAddress)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    // MARK: - Comment View

    private var commentView: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Order Comment")
                .font(.title2)
                .fontWeight(.bold)

            TextField("Add comment up to 200 characters", text: $orderComment)
                .onChange(of: orderComment) {
                    if orderComment.count > 200 {
                        orderComment = String(orderComment.prefix(200))
                    }
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))

            Text("\(orderComment.count)/200")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }

    // MARK: - Payment Method View

    private var paymentMethodView: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Payment Method")
                .font(.title2)
                .fontWeight(.bold)

            ForEach(PaymentMethod.allCases) { method in

                Button {

                    selectedPaymentMethod = method

                } label: {

                    HStack {

                        Image(
                            systemName: selectedPaymentMethod == method
                            ? "largecircle.fill.circle"
                            : "circle"
                        )
                        .foregroundStyle(.orange)

                        Text(method.rawValue)
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Total View

    private var totalView: some View {

        VStack(spacing: 14) {

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
                Text("Total")
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

    // MARK: - Confirm Order Button

    private var confirmOrderButton: some View {

        Button {

            let order = Order(
                items: cartViewModel.items,
                deliveryAddress: deliveryAddress,
                comment: orderComment,
                paymentMethod: selectedPaymentMethod,
                totalPrice: cartViewModel.totalPrice,
                status: "Waiting for restaurant confirmation",
                createdAt: Date()
            )

            orderViewModel.addOrder(order)
            showSuccessAlert = true

        } label: {
            Text("Place Order")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    isOrderButtonDisabled
                    ? Color.gray
                    : Color.orange
                )
                .clipShape(RoundedRectangle(cornerRadius: 22))
        }
        .disabled(isOrderButtonDisabled)
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        CheckoutView()
            .environmentObject(CartViewModel())
    }
}
