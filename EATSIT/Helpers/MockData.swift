//
//  MockData.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//
struct MockData {

    // MARK: - Dish Customizations Mock Data

    static let customizations: [DishCustomization] = [
        DishCustomization(
            name: "Extra Cheese",
            price: 1.00
        ),

        DishCustomization(
            name: "Jalapeños",
            price: 0.50
        ),

        DishCustomization(
            name: "Bacon",
            price: 2.00
        )
    ]

    static let profileOptions: [ProfileOption] = [

        ProfileOption(
            titleKey: "profile.paymentMethods",
            iconName: "creditcard.fill"
        ),

        ProfileOption(
            titleKey: "profile.deliveryAddresses",
            iconName: "location.fill"
        ),

        ProfileOption(
            titleKey: "profile.notifications",
            iconName: "bell.fill"
        ),

        ProfileOption(
            titleKey: "profile.language",
            iconName: "globe"
        ),

        ProfileOption(
            titleKey: "profile.help",
            iconName: "questionmark.circle.fill"
        )
    ]
}
