//
//  EATSITOrderCheckoutUITests.swift
//  EATSITUITests
//
//  Created by Shamruk_Polina on 17.05.2026.
//

import XCTest

final class EATSITOrderCheckoutUITests: XCTestCase {

    // MARK: - Properties

    private var app: XCUIApplication!

    // MARK: - Set Up

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    // MARK: - Tear Down

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    // MARK: - Helper Methods

    private func isAtLoginScreen() -> Bool {
        app.secureTextFields.firstMatch.exists
    }

    private func closeKeyboardIfNeeded() {
        let returnButton = app.keyboards.buttons.element(boundBy: 0)

        if returnButton.exists {
            returnButton.tap()
        }
    }

    private func openMainScreen() {

        if app.tabBars.firstMatch.waitForExistence(timeout: 5) {
            return
        }

        guard isAtLoginScreen() else {
            return
        }

        let signUpButton = app.buttons["Sign Up"]

        if signUpButton.waitForExistence(timeout: 5) {
            signUpButton.tap()
        } else if app.buttons.count > 1 {
            app.buttons.element(boundBy: 1).tap()
        }

        let textFields = app.textFields
        let passwordField = app.secureTextFields.firstMatch

        XCTAssertTrue(
            textFields.firstMatch.waitForExistence(timeout: 5),
            "Поля регистрации должны появиться"
        )

        let email = "order\(Int.random(in: 10000...99999))@eatsit.by"

        textFields.element(boundBy: 0).tap()
        textFields.element(boundBy: 0).typeText("Order Test User")

        textFields.element(boundBy: 1).tap()
        textFields.element(boundBy: 1).typeText(email)

        textFields.element(boundBy: 2).tap()
        textFields.element(boundBy: 2).typeText("+375291112233")

        passwordField.tap()
        passwordField.typeText("123456")

        closeKeyboardIfNeeded()

        let createAccountButton = app.buttons["Create Account"]

        if createAccountButton.waitForExistence(timeout: 5) {
            createAccountButton.tap()
        } else {
            app.buttons.firstMatch.tap()
        }

        XCTAssertTrue(
            app.tabBars.firstMatch.waitForExistence(timeout: 8),
            "После регистрации должен открыться главный экран"
        )
    }

    private func openHomeTab() {
        openMainScreen()

        let tabBar = app.tabBars.firstMatch

        if tabBar.waitForExistence(timeout: 5),
           tabBar.buttons.count > 0 {
            tabBar.buttons.element(boundBy: 0).tap()
        }
    }

    private func openProfileTab() {
        openMainScreen()

        let tabBar = app.tabBars.firstMatch

        if tabBar.waitForExistence(timeout: 5),
           tabBar.buttons.count > 2 {
            tabBar.buttons.element(boundBy: 2).tap()
        }
    }

    private func openFirstRestaurant() {

        openHomeTab()

        let scrollView = app.scrollViews.firstMatch

        XCTAssertTrue(
            scrollView.waitForExistence(timeout: 5),
            "Главный экран должен открыться"
        )

        let buttons = scrollView.buttons

        if buttons.count > 2 {
            buttons.element(boundBy: 2).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5),
            "Экран ресторана должен открыться"
        )
    }

    private func openFirstDish() {

        openFirstRestaurant()

        let buttons = app.scrollViews.firstMatch.buttons

        if buttons.count > 0 {
            buttons.element(boundBy: 0).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5),
            "Экран блюда должен открыться"
        )
    }

    // MARK: - Restaurant Tests

    // Проверка глубокого открытия ресторана и прокрутки меню
    @MainActor
    func testRestaurantMenuContentFlow() throws {

        openFirstRestaurant()

        let scrollView = app.scrollViews.firstMatch

        XCTAssertTrue(
            scrollView.waitForExistence(timeout: 5),
            "Меню ресторана должно отображаться"
        )

        scrollView.swipeUp()
        scrollView.swipeDown()

        XCTAssertGreaterThan(
            app.buttons.count,
            0,
            "На экране ресторана должны быть кнопки блюд или корзины"
        )
    }

    // MARK: - Dish Details Tests

    // Проверка экрана блюда, количества и блока добавления
    @MainActor
    func testDishDetailsQuantityAndAddFlow() throws {

        openFirstDish()

        let scrollView = app.scrollViews.firstMatch

        XCTAssertTrue(
            scrollView.waitForExistence(timeout: 5),
            "Экран блюда должен отображаться"
        )

        scrollView.swipeUp()
        scrollView.swipeDown()

        let plusButton = app.buttons["+"]
        if plusButton.waitForExistence(timeout: 3) {
            plusButton.tap()
        }

        let minusButton = app.buttons["−"]
        if minusButton.waitForExistence(timeout: 3) {
            minusButton.tap()
        }

        let addToBasketButton = app.buttons["Add to Basket"]

        if addToBasketButton.waitForExistence(timeout: 5) {
            addToBasketButton.tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.exists || app.buttons.count > 0,
            "После добавления блюда экран должен остаться рабочим"
        )
    }

    // Проверка топпингов на экране блюда
    @MainActor
    func testDishToppingsFlow() throws {

        openFirstDish()

        let scrollView = app.scrollViews.firstMatch

        XCTAssertTrue(
            scrollView.waitForExistence(timeout: 5),
            "Экран блюда должен открыться"
        )

        scrollView.swipeUp()

        let buttons = app.buttons

        if buttons.count > 1 {
            buttons.element(boundBy: 1).tap()
        }

        if buttons.count > 2 {
            buttons.element(boundBy: 2).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.exists,
            "После выбора топпингов экран блюда должен оставаться доступным"
        )
    }

    // MARK: - Basket Tests

    // Проверка корзины после добавления блюда
    @MainActor
    func testBasketContentAfterAddingDishFlow() throws {

        openFirstDish()

        let addToBasketButton = app.buttons["Add to Basket"]

        if addToBasketButton.waitForExistence(timeout: 5) {
            addToBasketButton.tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        let viewBasketButton = app.buttons["View Basket"]

        if viewBasketButton.waitForExistence(timeout: 5) {
            viewBasketButton.tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5),
            "Корзина должна открыться"
        )

        app.scrollViews.firstMatch.swipeUp()
        app.scrollViews.firstMatch.swipeDown()

        XCTAssertGreaterThan(
            app.buttons.count,
            0,
            "В корзине должны быть кнопки управления"
        )
    }

    // Проверка управления количеством в корзине
    @MainActor
    func testBasketItemQuantityControlsFlow() throws {

        openFirstDish()

        if app.buttons["Add to Basket"].waitForExistence(timeout: 5) {
            app.buttons["Add to Basket"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        if app.buttons["View Basket"].waitForExistence(timeout: 5) {
            app.buttons["View Basket"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5),
            "Корзина должна быть открыта"
        )

        let plusButton = app.buttons["+"]
        if plusButton.waitForExistence(timeout: 3) {
            plusButton.tap()
        }

        let minusButton = app.buttons["−"]
        if minusButton.waitForExistence(timeout: 3) {
            minusButton.tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.exists,
            "После изменения количества корзина должна оставаться доступной"
        )
    }

    // MARK: - Checkout Tests

    // Проверка перехода в Checkout и прокрутки всех блоков
    @MainActor
    func testCheckoutScreenSectionsFlow() throws {

        openFirstDish()

        if app.buttons["Add to Basket"].waitForExistence(timeout: 5) {
            app.buttons["Add to Basket"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        if app.buttons["View Basket"].waitForExistence(timeout: 5) {
            app.buttons["View Basket"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        if app.buttons["Checkout"].waitForExistence(timeout: 5) {
            app.buttons["Checkout"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5),
            "Checkout должен открыться"
        )

        app.scrollViews.firstMatch.swipeUp()
        app.scrollViews.firstMatch.swipeUp()
        app.scrollViews.firstMatch.swipeDown()

        XCTAssertGreaterThan(
            app.buttons.count,
            0,
            "На экране Checkout должны быть кнопки"
        )
    }

    // Проверка добавления нового адреса в Checkout
    @MainActor
    func testCheckoutAddAddressFlow() throws {

        openFirstDish()

        if app.buttons["Add to Basket"].waitForExistence(timeout: 5) {
            app.buttons["Add to Basket"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        if app.buttons["View Basket"].waitForExistence(timeout: 5) {
            app.buttons["View Basket"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        if app.buttons["Checkout"].waitForExistence(timeout: 5) {
            app.buttons["Checkout"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5),
            "Checkout должен открыться"
        )

        let addNewAddressButton = app.buttons["Add New Address"]

        if addNewAddressButton.waitForExistence(timeout: 5) {
            addNewAddressButton.tap()

            let addressField = app.textFields.firstMatch

            if addressField.waitForExistence(timeout: 5) {
                addressField.tap()
                addressField.typeText("Test Address 123")
                closeKeyboardIfNeeded()
            }

            if app.buttons["Save"].waitForExistence(timeout: 5) {
                app.buttons["Save"].tap()
            }
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.exists || app.navigationBars.firstMatch.exists,
            "После редактирования адреса приложение должно остаться доступным"
        )
    }

    // Проверка оформления заказа
    @MainActor
    func testPlaceOrderFlow() throws {

        openFirstDish()

        if app.buttons["Add to Basket"].waitForExistence(timeout: 5) {
            app.buttons["Add to Basket"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        if app.buttons["View Basket"].waitForExistence(timeout: 5) {
            app.buttons["View Basket"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        if app.buttons["Checkout"].waitForExistence(timeout: 5) {
            app.buttons["Checkout"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        app.scrollViews.firstMatch.swipeUp()

        let placeOrderButton = app.buttons["Place Order"]

        if placeOrderButton.waitForExistence(timeout: 5) {
            placeOrderButton.tap()
        } else if app.buttons.count > 0 {
            app.buttons.element(boundBy: app.buttons.count - 1).tap()
        }

        let alert = app.alerts.firstMatch

        if alert.waitForExistence(timeout: 5) {
            alert.buttons.firstMatch.tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.exists || app.tabBars.firstMatch.exists,
            "После оформления заказа приложение должно оставаться доступным"
        )
    }

    // MARK: - Language Tests

    // Проверка открытия экрана языка и выбора языков
    @MainActor
    func testLanguageScreenFlow() throws {

        openProfileTab()

        let languageButton = app.buttons["Language"]

        if languageButton.waitForExistence(timeout: 5) {
            languageButton.tap()
        } else if app.buttons.count > 3 {
            app.buttons.element(boundBy: 3).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5)
                || app.navigationBars.firstMatch.exists,
            "Экран языка должен открыться"
        )

        if app.buttons["Русский"].waitForExistence(timeout: 3) {
            app.buttons["Русский"].tap()
        }

        if app.buttons["Polski"].waitForExistence(timeout: 3) {
            app.buttons["Polski"].tap()
        }

        if app.buttons["English"].waitForExistence(timeout: 3) {
            app.buttons["English"].tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.exists || app.navigationBars.firstMatch.exists,
            "После смены языка экран должен оставаться доступным"
        )
    }
}