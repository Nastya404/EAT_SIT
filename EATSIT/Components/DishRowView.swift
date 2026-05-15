//
//  DishRowView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct DishRowView: View {

    // MARK: - Properties

    let dish: Dish

    @EnvironmentObject private var cartViewModel: CartViewModel

    // MARK: - Body

    var body: some View {

        HStack(spacing: 16) {

            dishImageView
            dishInfoView

            Spacer()

            addButton
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }

    // MARK: - Dish Image View

    private var dishImageView: some View {

        Image(dish.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 90, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - Dish Info View

    private var dishInfoView: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(dish.name)
                .font(.headline)

            Text(dish.description)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .lineLimit(2)

            Text("$\(dish.price, specifier: "%.2f")")
                .fontWeight(.bold)
                .foregroundStyle(.orange)
        }
    }

    // MARK: - Add Button

    private var addButton: some View {

        Button {

            let item = CartItem(
                dish: dish,
                quantity: 1,
                selectedToppings: []
            )

            cartViewModel.addItem(item)

        } label: {

            Image(systemName: "plus")
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(12)
                .background(Color.orange)
                .clipShape(Circle())
        }
    }
}

// MARK: - Preview

#Preview {

    DishRowView(
        dish: MockData.dishes[0]
    )
    .environmentObject(CartViewModel())
}
