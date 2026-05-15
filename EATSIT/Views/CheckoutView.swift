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

    @Environment(\.dismiss) private var dismiss

    @State private var selectedAddress = "Home"
    @State private var orderComment = ""
    @State private var selectedPaymentMethod: PaymentMethod = .onlineCard
    @State private var showSuccessAlert = false

    private let serviceFee = 0.50

    private var currentDeliveryAddress: String {
        selectedAddress == "Home"
            ? "42 Riverside Drive, Apt 3B"
            : "10 Business Center, Floor 5"
    }

    private var totalPrice: Double {
        cartViewModel.totalPrice + serviceFee
    }

    private var isOrderButtonDisabled: Bool {
        currentDeliveryAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || cartViewModel.items.isEmpty
    }

    // MARK: - Body

    var body: some View {

        ZStack(alignment: .bottom) {

            ScrollView {

                VStack(spacing: 22) {

                    headerView
                    orderSummaryView
                    deliveryAddressView
                    deliveryInstructionsView
                    paymentMethodView
                    totalBreakdownView
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 140)
            }
            .background(Color(.systemGray6))

            bottomOrderBar
        }
        .navigationBarBackButtonHidden(true)
        .alert("Order successfully placed!", isPresented: $showSuccessAlert) {
            Button("OK") {
                cartViewModel.clearCart()
            }
        }
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

            Text("Checkout")
                .font(.title)
                .fontWeight(.bold)

            Spacer()

            HStack(spacing: 6) {
                Image(systemName: "checkmark.shield")
                Text("Secure")
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.green)
        }
        .padding(.top, 12)
    }

    // MARK: - Order Summary View

    private var orderSummaryView: some View {

        VStack(alignment: .leading, spacing: 18) {

            sectionTitle(icon: "list.clipboard", title: "Order Summary")

            ForEach(cartViewModel.items) { item in

                HStack(spacing: 14) {

                    Image(item.dish.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 6) {

                        Text("\(item.quantity)x \(item.dish.name)")
                            .font(.headline)

                        if !item.selectedToppings.isEmpty {
                            Text(item.selectedToppings.map { $0.name }.joined(separator: ", "))
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                        }
                    }

                    Spacer()

                    Text(String(format: "$%.2f", item.totalPrice))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }
            }

            Divider()

            HStack {

                Spacer()

                Label("Add more items", systemImage: "plus.circle")
                    .font(.headline)
                    .foregroundStyle(.orange)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    // MARK: - Delivery Address View

    private var deliveryAddressView: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                sectionTitle(icon: "mappin", title: "Delivery Address")

                Spacer()

                Text("2 saved")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.orange.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            addressCard(
                title: "Home",
                subtitle: "42 Riverside Drive, Apt 3B",
                icon: "house",
                isDefault: true
            )

            addressCard(
                title: "Office",
                subtitle: "10 Business Center, Floor 5",
                icon: "building.2",
                isDefault: false
            )

            HStack(spacing: 10) {

                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundStyle(.orange)
                    .frame(width: 34, height: 34)
                    .overlay {
                        Circle()
                            .stroke(Color.orange, style: StrokeStyle(lineWidth: 2, dash: [5]))
                    }

                Text("Add New Address")
                    .font(.headline)
                    .foregroundStyle(.orange)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    // MARK: - Address Card

    private func addressCard(
        title: String,
        subtitle: String,
        icon: String,
        isDefault: Bool
    ) -> some View {

        let isSelected = selectedAddress == title

        return Button {

            selectedAddress = title

        } label: {

            HStack(spacing: 14) {

                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? .orange : .gray.opacity(0.5))

                VStack(alignment: .leading, spacing: 6) {

                    HStack {

                        Image(systemName: icon)
                            .foregroundStyle(isSelected ? .orange : .gray)

                        Text(title)
                            .font(.headline)
                            .foregroundStyle(isSelected ? Color.primary : Color.gray)

                        if isDefault {
                            Text("DEFAULT")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(Color.orange)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                    Text(subtitle)
                        .foregroundStyle(.gray)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "pencil")
                        .foregroundStyle(.orange)
                }
            }
            .padding()
            .background(isSelected ? Color.orange.opacity(0.06) : Color.white)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color.orange : Color.gray.opacity(0.25), lineWidth: 2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Delivery Instructions View

    private var deliveryInstructionsView: some View {

        VStack(alignment: .leading, spacing: 16) {

            sectionTitle(icon: "doc.text", title: "Delivery Instructions")

            ZStack(alignment: .topLeading) {

                TextEditor(text: $orderComment)
                    .frame(height: 110)
                    .padding(12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                    }
                    .onChange(of: orderComment) {
                        if orderComment.count > 200 {
                            orderComment = String(orderComment.prefix(200))
                        }
                    }

                if orderComment.isEmpty {
                    Text("e.g. Leave at the door, call on arrival, gate code #1234...")
                        .foregroundStyle(.gray.opacity(0.6))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 20)
                }

                VStack {

                    Spacer()

                    HStack {

                        Spacer()

                        Text("\(orderComment.count) / 200")
                            .font(.caption)
                            .foregroundStyle(.gray.opacity(0.7))
                            .padding(.trailing, 18)
                            .padding(.bottom, 12)
                    }
                }
                .frame(height: 110)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    // MARK: - Payment Method View

    private var paymentMethodView: some View {

        VStack(alignment: .leading, spacing: 14) {

            sectionTitle(icon: "creditcard", title: "Payment Method")

            paymentCard(
                method: .onlineCard,
                iconText: "VISA",
                title: "•••• •••• •••• 1234",
                subtitle: "Expires 09/28",
                trailingText: nil
            )

            paymentCard(
                method: .cash,
                iconText: "💵",
                title: "Cash on Delivery",
                subtitle: "Pay when your order arrives",
                trailingText: nil
            )

            paymentCard(
                method: .erip,
                iconText: "ERIP",
                title: "ERIP Payment",
                subtitle: "Pay via ERIP system",
                trailingText: "BY"
            )
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    // MARK: - Payment Card

    private func paymentCard(
        method: PaymentMethod,
        iconText: String,
        title: String,
        subtitle: String,
        trailingText: String?
    ) -> some View {

        let isSelected = selectedPaymentMethod == method

        return Button {

            selectedPaymentMethod = method

        } label: {

            HStack(spacing: 14) {

                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? .orange : .gray.opacity(0.5))

                Text(iconText)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(iconText == "VISA" || iconText == "ERIP" ? .white : .green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        iconText == "VISA"
                            ? Color.blue
                            : iconText == "ERIP"
                                ? Color.blue
                                : Color.green.opacity(0.12)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 4) {

                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }

                Spacer()

                if let trailingText {
                    Text(isSelected && trailingText == "SELECTED" ? "SELECTED" : trailingText)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(trailingText == "SELECTED" ? .white : .blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(trailingText == "SELECTED" ? Color.orange : Color.blue.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()
            .background(isSelected ? Color.orange.opacity(0.06) : Color.white)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color.orange : Color.gray.opacity(0.25), lineWidth: 2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Total Breakdown View

    private var totalBreakdownView: some View {

        VStack(alignment: .leading, spacing: 18) {

            sectionTitle(icon: "list.bullet.rectangle", title: "Total Breakdown")

            priceRow(
                title: "Items (\(cartViewModel.items.count))",
                value: String(format: "$%.2f", cartViewModel.totalPrice)
            )

            Divider()

            HStack {

                Text("Delivery Fee")
                    .foregroundStyle(.gray)

                Spacer()

                Text("$2.99")
                    .strikethrough()
                    .foregroundStyle(.gray.opacity(0.6))

                Text("Free")
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Divider()

            priceRow(
                title: "Service Fee",
                value: String(format: "$%.2f", serviceFee)
            )

            Divider()

            HStack {

                Text("Total to Pay")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Text(String(format: "$%.2f", totalPrice))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    // MARK: - Bottom Order Bar

    private var bottomOrderBar: some View {

        VStack(spacing: 14) {

            HStack {

                Label("Est. 15–20 min\ndelivery", systemImage: "truck.box")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)

                Spacer()

                Text(String(format: "$%.2f", totalPrice))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
            }

            Button {

                createOrder()

            } label: {

                HStack(spacing: 12) {

                    Image(systemName: "checkmark.circle")
                    Text(String(format: "Place Order — $%.2f", totalPrice))
                }
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isOrderButtonDisabled ? Color.gray : Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .disabled(isOrderButtonDisabled)
        }
        .padding(20)
        .background(Color.white)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: -4)
    }

    // MARK: - Helper Views

    private func sectionTitle(icon: String, title: String) -> some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .foregroundStyle(.orange)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
        }
    }

    private func priceRow(title: String, value: String) -> some View {

        HStack {

            Text(title)
                .foregroundStyle(.gray)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
    }

    // MARK: - Methods

    private func createOrder() {

        let order = Order(
            items: cartViewModel.items,
            deliveryAddress: currentDeliveryAddress,
            comment: orderComment,
            paymentMethod: selectedPaymentMethod,
            totalPrice: totalPrice,
            status: "Waiting for restaurant confirmation",
            createdAt: Date()
        )

        orderViewModel.addOrder(order)
        showSuccessAlert = true
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        CheckoutView()
            .environmentObject(CartViewModel())
            .environmentObject(OrderViewModel())
    }
}
