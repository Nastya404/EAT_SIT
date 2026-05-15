//
//  OrdersView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct OrdersView: View {

    // MARK: - Properties

    @EnvironmentObject private var orderViewModel: OrderViewModel

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 24) {

                    headerView

                    if orderViewModel.orders.isEmpty {
                        emptyOrdersView
                    } else {
                        pastOrdersSection
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Header View

    private var headerView: some View {

        HStack(alignment: .top) {

            VStack(alignment: .leading, spacing: 6) {

                Text("My Orders")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Track and reorder your meals")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Image(systemName: "slider.horizontal.3")
                .font(.title3)
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
    }

    // MARK: - Past Orders Section

    private var pastOrdersSection: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                HStack(spacing: 8) {

                    Circle()
                        .fill(Color.gray.opacity(0.35))
                        .frame(width: 8, height: 8)

                    Text("PAST ORDERS")
                        .font(.headline)
                        .foregroundStyle(.gray)
                }

                Spacer()

                Text("See all")
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
            }

            ForEach(orderViewModel.orders) { order in

                OrderCardView(order: order)
            }
        }
    }

    // MARK: - Empty Orders View

    private var emptyOrdersView: some View {

        VStack(spacing: 14) {

            Image(systemName: "list.clipboard")
                .font(.system(size: 54))
                .foregroundStyle(.orange)

            Text("No orders yet")
                .font(.title2)
                .fontWeight(.bold)

            Text("Your completed orders will appear here.")
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
    }
}

// MARK: - Preview

#Preview {

    OrdersView()
        .environmentObject(OrderViewModel())
}
