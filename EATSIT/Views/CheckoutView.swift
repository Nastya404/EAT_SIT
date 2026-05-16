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

    @State private var selectedAddress = "home"
    @State private var homeAddress = String(localized: "checkout.address.homeValue")
    @State private var officeAddress = String(localized: "checkout.address.officeValue")
    @State private var customAddress = ""
    @State private var editingAddressId = ""
    @State private var editingAddressText = ""
    @State private var showAddressEditor = false
    

    @State private var orderComment = ""
    @State private var selectedPaymentMethod: PaymentMethod = .onlineCard
    @State private var showSuccessAlert = false

    private let serviceFee = 0.50

    private var savedAddressCount: Int {
        customAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 2 : 3
    }

    private var currentDeliveryAddress: String {
        switch selectedAddress {
        case "home":
            return homeAddress
        case "office":
            return officeAddress
        case "custom":
            return customAddress
        default:
            return homeAddress
        }
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
        .alert("checkout.success", isPresented: $showSuccessAlert) {
            Button("checkout.ok") {
                cartViewModel.clearCart()
            }
        }
        .sheet(isPresented: $showAddressEditor) {
            addressEditorView
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

            Text("checkout.title")
                .font(.title)
                .fontWeight(.bold)

            Spacer()

            HStack(spacing: 6) {
                Image(systemName: "checkmark.shield")
                Text("checkout.secure")
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

            sectionTitle(icon: "list.clipboard", titleKey: "checkout.orderSummary")

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

                Label("checkout.addMoreItems", systemImage: "plus.circle")
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

                sectionTitle(icon: "mappin", titleKey: "checkout.deliveryAddress")

                Spacer()

                Text(String(format: String(localized: "checkout.savedAddresses"), savedAddressCount))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.orange.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            addressCard(
                id: "home",
                titleKey: "checkout.address.home",
                subtitle: homeAddress,
                icon: "house",
                isDefault: true
            )

            addressCard(
                id: "office",
                titleKey: "checkout.address.office",
                subtitle: officeAddress,
                icon: "building.2",
                isDefault: false
            )

            if !customAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                addressCard(
                    id: "custom",
                    titleKey: "checkout.address.custom",
                    subtitle: customAddress,
                    icon: "mappin.and.ellipse",
                    isDefault: false
                )
            }

            Button {

                startEditingAddress(id: "custom")

            } label: {

                HStack(spacing: 10) {

                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundStyle(.orange)
                        .frame(width: 34, height: 34)
                        .overlay {
                            Circle()
                                .stroke(Color.orange, style: StrokeStyle(lineWidth: 2, dash: [5]))
                        }

                    Text("checkout.addNewAddress")
                        .font(.headline)
                        .foregroundStyle(.orange)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    // MARK: - Address Card

    private func addressCard(
        id: String,
        titleKey: String,
        subtitle: String,
        icon: String,
        isDefault: Bool
    ) -> some View {

        let isSelected = selectedAddress == id

        return Button {

            selectedAddress = id

        } label: {

            HStack(spacing: 14) {

                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? .orange : .gray.opacity(0.5))

                VStack(alignment: .leading, spacing: 6) {

                    HStack {

                        Image(systemName: icon)
                            .foregroundStyle(isSelected ? .orange : .gray)

                        Text(LocalizedStringKey(titleKey))
                            .font(.headline)
                            .foregroundStyle(isSelected ? Color.primary : Color.gray)

                        if isDefault {
                            Text("checkout.address.default")
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

                Button {

                    startEditingAddress(id: id)

                } label: {

                    Image(systemName: "pencil")
                        .foregroundStyle(.orange)
                        .frame(width: 44, height: 44)
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

    // MARK: - Address Editor View

    private var addressEditorView: some View {

        NavigationStack {

            VStack(alignment: .leading, spacing: 20) {

                Text("checkout.addressEditor.description")
                    .font(.subheadline)
                    .foregroundStyle(.gray)

                TextField("checkout.addressEditor.placeholder", text: $editingAddressText)
                    .textFieldStyle(.roundedBorder)
                
                if editingAddressId == "custom",
                   !customAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {

                    Button(role: .destructive) {
                        deleteCustomAddress()
                    } label: {
                        Label("checkout.deleteAddress", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding(20)
            .navigationTitle("checkout.addressEditor.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .cancellationAction) {
                    Button("checkout.cancel") {
                        showAddressEditor = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("checkout.save") {
                        saveEditedAddress()
                    }
                    .disabled(editingAddressText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    // MARK: - Delivery Instructions View

    private var deliveryInstructionsView: some View {

        VStack(alignment: .leading, spacing: 16) {

            sectionTitle(icon: "doc.text", titleKey: "checkout.instructions")

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
                    Text("checkout.instructionsPlaceholder")
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

            sectionTitle(icon: "creditcard", titleKey: "checkout.paymentMethod")

            paymentCard(
                method: .onlineCard,
                iconText: "VISA",
                titleKey: "checkout.cardTitle",
                subtitleKey: "checkout.cardSubtitle",
                trailingText: nil
            )

            paymentCard(
                method: .cash,
                iconText: "💵",
                titleKey: "checkout.cashTitle",
                subtitleKey: "checkout.cashSubtitle",
                trailingText: nil
            )

            paymentCard(
                method: .erip,
                iconText: "ERIP",
                titleKey: "checkout.eripTitle",
                subtitleKey: "checkout.eripSubtitle",
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
        titleKey: String,
        subtitleKey: String,
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

                    Text(LocalizedStringKey(titleKey))
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(LocalizedStringKey(subtitleKey))
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

            sectionTitle(icon: "list.bullet.rectangle", titleKey: "checkout.totalBreakdown")

            priceRow(
                titleKey: "checkout.items",
                value: String(format: "$%.2f", cartViewModel.totalPrice)
            )

            Divider()

            HStack {

                Text("checkout.deliveryFee")
                    .foregroundStyle(.gray)

                Spacer()

                Text("$2.99")
                    .strikethrough()
                    .foregroundStyle(.gray.opacity(0.6))

                Text("checkout.free")
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Divider()

            priceRow(
                titleKey: "checkout.serviceFee",
                value: String(format: "$%.2f", serviceFee)
            )

            Divider()

            HStack {

                Text("checkout.totalToPay")
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

                Label("checkout.deliveryEstimate", systemImage: "truck.box")
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
                    Text(
                        String(localized: "checkout.placeOrder") +
                        String(format: " — $%.2f", totalPrice)
                    )
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

    private func sectionTitle(icon: String, titleKey: String) -> some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .foregroundStyle(.orange)

            Text(LocalizedStringKey(titleKey))
                .font(.title2)
                .fontWeight(.bold)
        }
    }

    private func priceRow(titleKey: String, value: String) -> some View {

        HStack {

            Text(LocalizedStringKey(titleKey))
                .foregroundStyle(.gray)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
    }

    // MARK: - Methods

    private func startEditingAddress(id: String) {

        editingAddressId = id

        switch id {
        case "home":
            editingAddressText = homeAddress
        case "office":
            editingAddressText = officeAddress
        default:
            editingAddressText = customAddress
        }

        showAddressEditor = true
    }

    private func saveEditedAddress() {

        let trimmedAddress = editingAddressText.trimmingCharacters(in: .whitespacesAndNewlines)

        switch editingAddressId {
        case "home":
            homeAddress = trimmedAddress
        case "office":
            officeAddress = trimmedAddress
        default:
            customAddress = trimmedAddress
            selectedAddress = "custom"
        }

        showAddressEditor = false
    }

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
    
    private func deleteCustomAddress() {

        customAddress = ""

        if selectedAddress == "custom" {
            selectedAddress = "home"
        }

        showAddressEditor = false
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
