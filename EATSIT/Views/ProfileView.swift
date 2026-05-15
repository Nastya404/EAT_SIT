//
//  ProfileView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct ProfileView: View {

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 24) {

                    headerView
                    userCardView
                    optionsView
                    logoutButton
                }
                .padding(20)
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Header View

    private var headerView: some View {

        HStack {

            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()

            Image(systemName: "ellipsis")
                .font(.title3)
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    // MARK: - User Card View

    private var userCardView: some View {

        VStack(spacing: 16) {

            Image(systemName: "person.circle.fill")
                .font(.system(size: 96))
                .foregroundStyle(.orange)

            Text("Alex Johnson")
                .font(.title)
                .fontWeight(.bold)

            VStack(spacing: 4) {

                Text("alex.johnson@email.com")
                Text("+1 (555) 012-3456")
            }
            .font(.subheadline)
            .foregroundStyle(.gray)

            statisticsView
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    // MARK: - Statistics View

    private var statisticsView: some View {

        HStack {

            statisticItem(title: "Orders", value: "24")
            Divider()
            statisticItem(title: "Reviews", value: "8")
            Divider()
            statisticItem(title: "Points", value: "320")
        }
        .frame(height: 72)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }

    // MARK: - Options View

    private var optionsView: some View {

        VStack(spacing: 0) {

            ForEach(MockData.profileOptions) { option in

                ProfileOptionRowView(option: option)

                if option.id != MockData.profileOptions.last?.id {
                    Divider()
                        .padding(.leading, 64)
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 26))
    }

    // MARK: - Logout Button

    private var logoutButton: some View {

        Button {

        } label: {

            HStack {

                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Log Out")
            }
            .font(.headline)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
    }

    // MARK: - Methods

    private func statisticItem(title: String, value: String) -> some View {

        VStack(spacing: 6) {

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {

    ProfileView()
}
