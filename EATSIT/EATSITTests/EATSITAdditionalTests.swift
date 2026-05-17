//
//  EATSITAdditionalTests.swift
//  EATSITTests
//
//  Created by Shamruk_Polina on 17.05.2026.
//

import XCTest
@testable import EATSIT

final class EATSITAdditionalTests: XCTestCase {

    // MARK: - Properties

    private let languageKey = "selectedLanguage"

    // MARK: - Set Up

    override func setUpWithError() throws {
        try super.setUpWithError()

        UserDefaults.standard.removeObject(forKey: languageKey)
        UserDefaults.standard.synchronize()
    }

    // MARK: - PaymentMethod Tests

    func testPaymentMethodIdsMatchRawValues() {

        PaymentMethod.allCases.forEach { method in
            XCTAssertEqual(method.id, method.rawValue)
        }
    }

    func testPaymentMethodContainsAllRequiredCases() {

        XCTAssertTrue(PaymentMethod.allCases.contains(.onlineCard))
        XCTAssertTrue(PaymentMethod.allCases.contains(.erip))
        XCTAssertTrue(PaymentMethod.allCases.contains(.terminal))
        XCTAssertTrue(PaymentMethod.allCases.contains(.cash))
    }

    // MARK: - AppLanguage Tests

    func testAppLanguageIdsMatchRawValues() {

        AppLanguage.allCases.forEach { language in
            XCTAssertEqual(language.id, language.rawValue)
        }
    }

    func testAppLanguageTitlesAreNotEmpty() {

        AppLanguage.allCases.forEach { language in
            XCTAssertFalse(language.title.isEmpty)
        }
    }

    func testAppLanguageFlagsAreNotEmpty() {

        AppLanguage.allCases.forEach { language in
            XCTAssertFalse(language.flag.isEmpty)
        }
    }

    func testAppLanguagePolishProperties() {

        XCTAssertEqual(AppLanguage.polish.id, "pl")
        XCTAssertEqual(AppLanguage.polish.title, "Polski")
        XCTAssertEqual(AppLanguage.polish.flag, "🇵🇱")
    }

    // MARK: - Model Tests

    func testProfileOptionCreatesUniqueIdentifier() {

        let option = ProfileOption(
            titleKey: "profile.language",
            iconName: "globe"
        )

        XCTAssertFalse(option.id.uuidString.isEmpty)
        XCTAssertEqual(option.titleKey, "profile.language")
        XCTAssertEqual(option.iconName, "globe")
    }

    func testDishCustomizationCreatesUniqueIdentifier() {

        let customization = DishCustomization(
            name: "Extra Cheese",
            price: 2.50
        )

        XCTAssertFalse(customization.id.uuidString.isEmpty)
        XCTAssertEqual(customization.name, "Extra Cheese")
        XCTAssertEqual(customization.price, 2.50)
    }

    func testOrderStoresProvidedData() {

        let dish = Dish(
            id: "test_dish",
            restaurantId: "test_restaurant",
            name: "Test Dish",
            description: "Test description",
            price: 10.00,
            imageName: "test_image",
            category: "test_category",
            restaurantName: "Test Restaurant"
        )

        let item = CartItem(
            dish: dish,
            quantity: 2,
            selectedToppings: []
        )

        let date = Date()

        let order = Order(
            items: [item],
            deliveryAddress: "Test Address",
            comment: "Test Comment",
            paymentMethod: .cash,
            totalPrice: 20.00,
            status: "Created",
            createdAt: date
        )

        XCTAssertFalse(order.id.uuidString.isEmpty)
        XCTAssertEqual(order.items.count, 1)
        XCTAssertEqual(order.deliveryAddress, "Test Address")
        XCTAssertEqual(order.comment, "Test Comment")
        XCTAssertEqual(order.paymentMethod, .cash)
        XCTAssertEqual(order.totalPrice, 20.00)
        XCTAssertEqual(order.status, "Created")
        XCTAssertEqual(order.createdAt, date)
    }

    // MARK: - DatabaseManager Tests

    func testDatabaseFetchRestaurantsDoesNotCrash() {

        let restaurants = DatabaseManager.shared.fetchRestaurants()

        XCTAssertNotNil(restaurants)
    }

    func testDatabaseFetchDishesDoesNotCrash() {

        let dishes = DatabaseManager.shared.fetchDishes()

        XCTAssertNotNil(dishes)
    }

    func testDatabaseFetchRestaurantsForDifferentLanguages() {

        UserDefaults.standard.set("en", forKey: languageKey)
        let englishRestaurants = DatabaseManager.shared.fetchRestaurants()

        UserDefaults.standard.set("ru", forKey: languageKey)
        let russianRestaurants = DatabaseManager.shared.fetchRestaurants()

        UserDefaults.standard.set("pl", forKey: languageKey)
        let polishRestaurants = DatabaseManager.shared.fetchRestaurants()

        XCTAssertNotNil(englishRestaurants)
        XCTAssertNotNil(russianRestaurants)
        XCTAssertNotNil(polishRestaurants)
    }

    func testDatabaseFetchDishesForDifferentLanguages() {

        UserDefaults.standard.set("en", forKey: languageKey)
        let englishDishes = DatabaseManager.shared.fetchDishes()

        UserDefaults.standard.set("ru", forKey: languageKey)
        let russianDishes = DatabaseManager.shared.fetchDishes()

        UserDefaults.standard.set("pl", forKey: languageKey)
        let polishDishes = DatabaseManager.shared.fetchDishes()

        XCTAssertNotNil(englishDishes)
        XCTAssertNotNil(russianDishes)
        XCTAssertNotNil(polishDishes)
    }

    func testDatabaseFetchLocationsForRestaurant() {

        let restaurants = DatabaseManager.shared.fetchRestaurants()

        guard let restaurant = restaurants.first else {
            return
        }

        let locations = DatabaseManager.shared.fetchLocations(for: restaurant)

        XCTAssertNotNil(locations)
    }

    func testDatabaseFetchCustomizationsForDish() {

        let dishes = DatabaseManager.shared.fetchDishes()

        guard let dish = dishes.first else {
            return
        }

        let customizations = DatabaseManager.shared.fetchCustomizations(for: dish)

        XCTAssertNotNil(customizations)
    }

    // MARK: - ViewModel Tests

    func testHomeViewModelLoadsRestaurants() {

        let viewModel = HomeViewModel()

        viewModel.loadRestaurants()

        XCTAssertEqual(
            viewModel.restaurants.count,
            DatabaseManager.shared.fetchRestaurants().count
        )
    }

    func testRestaurantViewModelLoadsDishesForRestaurant() {

        let restaurants = DatabaseManager.shared.fetchRestaurants()

        guard let restaurant = restaurants.first else {
            return
        }

        let viewModel = RestaurantViewModel(restaurant: restaurant)

        viewModel.loadDishes()

        let expectedDishes = DatabaseManager.shared.fetchDishes(for: restaurant)

        XCTAssertEqual(viewModel.dishes.count, expectedDishes.count)
    }

    func testOrderViewModelLoadsOrders() {

        let viewModel = OrderViewModel()

        viewModel.loadOrders()

        XCTAssertNotNil(viewModel.orders)
    }

    func testOrderViewModelAddsOrder() {

        let viewModel = OrderViewModel()
        let uniqueAddress = "Test Address \(UUID().uuidString)"

        let order = Order(
            items: [],
            deliveryAddress: uniqueAddress,
            comment: "Test order comment",
            paymentMethod: .cash,
            totalPrice: 15.00,
            status: "Created",
            createdAt: Date()
        )

        viewModel.addOrder(order)

        XCTAssertTrue(
            viewModel.orders.contains {
                $0.deliveryAddress == uniqueAddress
            }
        )
    }
}
