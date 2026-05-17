//
//  DishDetailsView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct DishDetailsView: View {

    // MARK: - Properties

    let dish: Dish

    @EnvironmentObject private var cartViewModel: CartViewModel

    @State private var quantity = 1
    @State private var customizations: [DishCustomization] = []
    @State private var selectedCustomizations: Set<UUID> = []

    private var toppingsTotal: Double {
        customizations
            .filter { selectedCustomizations.contains($0.id) }
            .reduce(0) { $0 + $1.price }
    }

    private var selectedToppings: [DishCustomization] {
        customizations.filter {
            selectedCustomizations.contains($0.id)
        }
    }

    private var totalPrice: Double {
        (dish.price + toppingsTotal) * Double(quantity)
    }

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                dishImageView
                dishInfoView
                toppingsView
                quantityView
            }
            .padding(.bottom, 170)
        }
        .background(Color(.systemGray6))
        .safeAreaInset(edge: .bottom) {
            bottomButtonsView
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadCustomizations()
        }
    }

    // MARK: - Dish Image View

    private var dishImageView: some View {

        Image(dish.imageName)
            .resizable()
            .scaledToFill()
            .frame(height: 240)
            .frame(maxWidth: .infinity)
            .clipped()
    }

    // MARK: - Dish Info View

    private var dishInfoView: some View {

        VStack(alignment: .leading, spacing: 14) {

            VStack(alignment: .leading, spacing: 8) {

                Text(dish.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(3)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(alignment: .bottom, spacing: 6) {

                    Text("$\(dish.price, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)

                    Text("dish.perItem")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }

            Text(dish.description)
                .font(.body)
                .foregroundStyle(.gray)
                .lineLimit(4)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 10) {

                Label("dish.popular", systemImage: "flame.fill")
                    .foregroundStyle(.orange)
                    .padding(8)
                    .background(Color.orange.opacity(0.12))
                    .clipShape(Capsule())

                Label("4.9", systemImage: "star.fill")
                    .foregroundStyle(.green)
                    .padding(8)
                    .background(Color.green.opacity(0.12))
                    .clipShape(Capsule())
            }
            .font(.subheadline)
            .fontWeight(.semibold)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .padding(.horizontal, 20)
    }
    // MARK: - Toppings View

    private var toppingsView: some View {

        VStack(alignment: .leading, spacing: 18) {

            Text("dish.addToppings")
                .font(.title2)
                .fontWeight(.bold)

            ForEach(customizations) { customization in

                Button {

                    toggleCustomization(customization)

                } label: {

                    HStack {

                        Image(
                            systemName: selectedCustomizations.contains(customization.id)
                            ? "checkmark.square.fill"
                            : "square"
                        )
                        .font(.title2)
                        .foregroundStyle(.orange)

                        Text(customization.name)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Spacer()

                        Text("+$\(customization.price, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundStyle(.orange)
                    }
                }
                .buttonStyle(.plain)

                Divider()
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .padding(.horizontal, 20)
    }

    // MARK: - Quantity View

    private var quantityView: some View {

        VStack(alignment: .leading, spacing: 18) {

            Text("dish.quantity")
                .font(.title2)
                .fontWeight(.bold)

            HStack {

                Button {
                    decreaseQuantity()
                } label: {
                    Text("−")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: 70, height: 54)
                        .background(Color.orange.opacity(0.1))
                }

                Text("\(quantity)")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 80, height: 54)

                Button {
                    increaseQuantity()
                } label: {
                    Text("+")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 70, height: 54)
                        .background(Color.orange)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .padding(.horizontal, 20)
    }

    // MARK: - Bottom Buttons View

    private var bottomButtonsView: some View {

        VStack(spacing: 10) {

            addToBasketButton

            if !cartViewModel.items.isEmpty {
                basketNavigationButton
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .background(.ultraThinMaterial)
    }

    // MARK: - Add To Basket Button

    private var addToBasketButton: some View {

        Button {

            let item = CartItem(
                dish: dish,
                quantity: quantity,
                selectedToppings: selectedToppings
            )

            cartViewModel.addItem(item)

        } label: {

            HStack(spacing: 6) {

                Text("dish.addToBasket")
                Text(String(format: "— $%.2f", totalPrice))
            }
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
    }

    // MARK: - Basket Navigation Button

    private var basketNavigationButton: some View {

        NavigationLink {

            BasketView()

        } label: {

            HStack {

                Image(systemName: "basket.fill")
                Text("restaurant.viewBasket")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(.orange)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    // MARK: - Methods

    private func loadCustomizations() {

        customizations = DatabaseManager.shared.fetchCustomizations(for: dish)
    }

    private func toggleCustomization(_ customization: DishCustomization) {

        if selectedCustomizations.contains(customization.id) {
            selectedCustomizations.remove(customization.id)
        } else {
            selectedCustomizations.insert(customization.id)
        }
    }

    private func increaseQuantity() {

        quantity += 1
    }

    private func decreaseQuantity() {

        if quantity > 1 {
            quantity -= 1
        }
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        DishDetailsView(
            dish: Dish(
                id: "preview",
                restaurantId: "preview",
                name: "Preview Dish",
                description: "Preview description",
                price: 12.00,
                imageName: "dish_snickers_cake",
                category: "desserts",
                restaurantName: "Preview Restaurant"
            )
        )
        .environmentObject(CartViewModel())
    }
}
