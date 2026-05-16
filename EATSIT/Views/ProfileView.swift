//
//  ProfileView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct ProfileView: View {

    // MARK: - Properties

    @State private var showLogoutAlert = false

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
            .alert("profile.logoutTitle", isPresented: $showLogoutAlert) {
                Button("profile.cancel", role: .cancel) { }
                Button("profile.logout", role: .destructive) { }
            } message: {
                Text("profile.logoutMessage")
            }
        }
    }

    // MARK: - Header View

    private var headerView: some View {

        HStack {

            Text("profile.title")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()

            NavigationLink {

                ProfileDetailsView()

            } label: {

                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(.plain)
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
                    .foregroundStyle(.orange)

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

            statisticItem(titleKey: "profile.orders", value: "24")
            Divider()
            statisticItem(titleKey: "profile.reviews", value: "8")
            Divider()
            statisticItem(titleKey: "profile.points", value: "320")
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

                profileOptionLink(for: option)

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

            showLogoutAlert = true

        } label: {

            HStack {

                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("profile.logout")
            }
            .font(.headline)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
    }

    // MARK: - Helper Views

    private func statisticItem(titleKey: String, value: String) -> some View {

        VStack(spacing: 6) {

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(LocalizedStringKey(titleKey))
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
    }

    private func profileOptionLink(for option: ProfileOption) -> some View {

        NavigationLink {

            destinationView(for: option)

        } label: {

            ProfileOptionRowView(option: option)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func destinationView(for option: ProfileOption) -> some View {

        switch option.titleKey {
        case "profile.paymentMethods":
            ProfileInfoView(
                titleKey: "profile.paymentMethods",
                iconName: "creditcard.fill",
                rows: [
                    "VISA •••• 1234",
                    "Cash on Delivery",
                    "ERIP Payment"
                ]
            )

        case "profile.deliveryAddresses":
            ProfileInfoView(
                titleKey: "profile.deliveryAddresses",
                iconName: "location.fill",
                rows: [
                    String(localized: "checkout.address.homeValue"),
                    String(localized: "checkout.address.officeValue")
                ]
            )

        case "profile.notifications":
            NotificationsSettingsView()

        case "profile.language":
            LanguageView()

        case "profile.help":
            ProfileInfoView(
                titleKey: "profile.help",
                iconName: "questionmark.circle.fill",
                rows: [
                    String(localized: "profile.help.faq"),
                    String(localized: "profile.help.support"),
                    String(localized: "profile.help.terms")
                ]
            )

        default:
            ProfileInfoView(
                titleKey: option.titleKey,
                iconName: option.iconName,
                rows: []
            )
        }
    }
}

// MARK: - Profile Details View

private struct ProfileDetailsView: View {

    // MARK: - Body

    var body: some View {

        List {

            Section("profile.personalInfo") {

                profileRow(titleKey: "profile.name", value: "Alex Johnson")
                profileRow(titleKey: "profile.email", value: "alex.johnson@email.com")
                profileRow(titleKey: "profile.phone", value: "+1 (555) 012-3456")
            }

            Section("profile.account") {

                profileRow(titleKey: "profile.status", value: "Active")
                profileRow(titleKey: "profile.memberSince", value: "2026")
            }
        }
        .navigationTitle("profile.details")
    }

    // MARK: - Helper Views

    private func profileRow(titleKey: String, value: String) -> some View {

        HStack {

            Text(LocalizedStringKey(titleKey))

            Spacer()

            Text(value)
                .foregroundStyle(.gray)
        }
    }
}

// MARK: - Profile Info View

private struct ProfileInfoView: View {

    // MARK: - Properties

    let titleKey: String
    let iconName: String
    let rows: [String]

    // MARK: - Body

    var body: some View {

        List {

            if rows.isEmpty {

                Text("profile.emptySection")
                    .foregroundStyle(.gray)

            } else {

                ForEach(rows, id: \.self) { row in

                    HStack(spacing: 12) {

                        Image(systemName: iconName)
                            .foregroundStyle(.orange)

                        Text(row)
                    }
                }
            }
        }
        .navigationTitle(LocalizedStringKey(titleKey))
    }
}

// MARK: - Notifications Settings View

private struct NotificationsSettingsView: View {

    // MARK: - Properties

    @State private var orderUpdatesEnabled = true
    @State private var promotionsEnabled = false
    @State private var deliveryStatusEnabled = true

    // MARK: - Body

    var body: some View {

        List {

            Toggle("profile.notifications.orderUpdates", isOn: $orderUpdatesEnabled)
            Toggle("profile.notifications.promotions", isOn: $promotionsEnabled)
            Toggle("profile.notifications.deliveryStatus", isOn: $deliveryStatusEnabled)
        }
        .navigationTitle("profile.notifications")
    }
}

// MARK: - Preview

#Preview {

    ProfileView()
}
