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

    @EnvironmentObject private var cartViewModel: CartViewModel

    private var toppingsText: String {
        item.selectedToppings.map { $0.name }.joined(separator: ", ")
    }

    // MARK: - Body

    var body: some View {

        VStack(spacing: 18) {

            topInfoView

            Divider()

            bottomControlsView
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 5)
    }

    // MARK: - Top Info View

    private var topInfoView: some View {

        HStack(alignment: .top, spacing: 14) {

            ZStack(alignment: .bottomTrailing) {

                Image(item.dish.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 92, height: 92)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                Text("\(item.quantity)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 26, height: 26)
                    .background(Color.orange)
                    .clipShape(Circle())
                    .offset(x: 8, y: 8)
            }

            VStack(alignment: .leading, spacing: 8) {

                Text(item.dish.name)
                    .font(.headline)
                    .lineLimit(2)

                if !item.selectedToppings.isEmpty {
                    Text(toppingsText)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(1)

                    Text("basket.toppings")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.1))
                        .clipShape(Capsule())
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {

                Text(String(format: "$%.2f", item.totalPrice))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)

                Text(String(format: "$%.2f", item.dish.price))
                    .font(.caption)
                    .strikethrough()
                    .foregroundStyle(.gray.opacity(0.7))
            }
        }
    }

    // MARK: - Bottom Controls View

    private var bottomControlsView: some View {

        HStack {

            Text(LocalizedStringKey("basket.quantity"))
                .foregroundStyle(.gray)

            Spacer()

            quantityControl

            Button {

                cartViewModel.removeItem(item)

            } label: {

                Image(systemName: "trash")
                    .font(.headline)
                    .foregroundStyle(.red)
                    .frame(width: 40, height: 40)
            }
        }
    }

    // MARK: - Quantity Control

    private var quantityControl: some View {

        HStack(spacing: 0) {

            Button {
                cartViewModel.decreaseQuantity(for: item)
            } label: {
                Text("−")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
                    .frame(width: 44, height: 40)
            }

            Text("\(item.quantity)")
                .font(.title3)
                .fontWeight(.bold)
                .frame(width: 46, height: 40)

            Button {
                cartViewModel.increaseQuantity(for: item)
            } label: {
                Text("+")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 40)
                    .background(Color.orange)
            }
        }
        .background(Color.orange.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.orange.opacity(0.25))
        }
    }
}

// MARK: - Preview

#Preview {

    BasketItemView(
        item: CartItem(
            dish: Dish(
                id: "preview_dish",
                restaurantId: "preview_restaurant",
                name: "Cheese Burger",
                description: "Juicy burger with cheddar cheese",
                price: 12.99,
                imageName: "dish_cheese_burger",
                category: "fast_food",
                restaurantName: "Burger King"
            ),
            quantity: 1,
            selectedToppings: [
                DishCustomization(
                    name: "Extra Cheese",
                    price: 1.00
                ),
                DishCustomization(
                    name: "Bacon",
                    price: 2.00
                )
            ]
        )
    )
    .environmentObject(CartViewModel())
}
