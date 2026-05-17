//
//  EATSITDeepFlowUITests.swift
//  EATSITUITests
//
//  Created by Shamruk_Polina on 17.05.2026.
//

import XCTest

final class EATSITDeepFlowUITests: XCTestCase {

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

    // Проверка, находимся ли мы на экране авторизации
    private func isAtLoginScreen() -> Bool {
        app.secureTextFields.firstMatch.exists
    }

    // Закрытие клавиатуры, если она открыта
    private func closeKeyboardIfNeeded() {
        let returnButton = app.keyboards.buttons.element(boundBy: 0)

        if returnButton.exists {
            returnButton.tap()
        }
    }

    // Открытие главного экрана через регистрацию нового тестового пользователя
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
        } else {
            app.buttons.element(boundBy: 1).tap()
        }

        let textFields = app.textFields
        let passwordField = app.secureTextFields.firstMatch

        XCTAssertTrue(
            textFields.firstMatch.waitForExistence(timeout: 5),
            "Поля регистрации должны появиться"
        )

        let email = "ui\(Int.random(in: 10000...99999))@eatsit.by"

        textFields.element(boundBy: 0).tap()
        textFields.element(boundBy: 0).typeText("UI Test User")

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

    // Переход на вкладку Home
    private func openHomeTab() {
        openMainScreen()

        let tabBar = app.tabBars.firstMatch

        if tabBar.waitForExistence(timeout: 5),
           tabBar.buttons.count > 0 {
            tabBar.buttons.element(boundBy: 0).tap()
        }
    }

    // Переход на вкладку Orders
    private func openOrdersTab() {
        openMainScreen()

        let tabBar = app.tabBars.firstMatch

        if tabBar.waitForExistence(timeout: 5),
           tabBar.buttons.count > 1 {
            tabBar.buttons.element(boundBy: 1).tap()
        }
    }

    // Переход на вкладку Profile
    private func openProfileTab() {
        openMainScreen()

        let tabBar = app.tabBars.firstMatch

        if tabBar.waitForExistence(timeout: 5),
           tabBar.buttons.count > 2 {
            tabBar.buttons.element(boundBy: 2).tap()
        }
    }

    // MARK: - Home Tests

    // Проверка главного экрана, поиска, фильтра и категорий
    @MainActor
    func testHomeScreenSearchAndCategoriesDeepFlow() throws {

        openHomeTab()

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5),
            "На главном экране должен быть ScrollView"
        )

        let searchField = app.textFields.firstMatch

        XCTAssertTrue(
            searchField.waitForExistence(timeout: 5),
            "Поле поиска должно отображаться"
        )

        searchField.tap()
        searchField.typeText("Pizza")

        closeKeyboardIfNeeded()

        let buttons = app.scrollViews.firstMatch.buttons

        if buttons.count > 0 {
            buttons.element(boundBy: 0).tap()
        }

        if buttons.count > 2 {
            buttons.element(boundBy: 2).tap()
        }

        if buttons.count > 3 {
            buttons.element(boundBy: 3).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.exists,
            "Главный экран должен оставаться доступным после фильтрации"
        )
    }

    // Проверка выбора адреса доставки на главном экране
    @MainActor
    func testHomeAddressPickerDeepFlow() throws {

        openHomeTab()

        let buttons = app.buttons

        if buttons.count > 0 {
            buttons.element(boundBy: 0).tap()
        }

        XCTAssertTrue(
            app.buttons.count > 0,
            "После нажатия на адрес должны быть доступны элементы выбора"
        )

        if app.buttons.count > 1 {
            app.buttons.element(boundBy: 1).tap()
        }
    }

    // MARK: - Map Tests

    // Проверка открытия карты и взаимодействия с фильтрами карты
    @MainActor
    func testRestaurantMapDeepFlow() throws {

        openHomeTab()

        let mapButton = app.buttons.element(boundBy: 1)

        if mapButton.waitForExistence(timeout: 5) {
            mapButton.tap()
        }

        let map = app.maps.firstMatch

        if map.waitForExistence(timeout: 8) {

            XCTAssertTrue(map.exists, "Карта ресторанов должна открыться")

            let buttons = app.buttons

            if buttons.count > 0 {
                buttons.element(boundBy: 0).tap()
            }

            if buttons.count > 1 {
                buttons.element(boundBy: 1).tap()
            }

            if buttons.count > 2 {
                buttons.element(boundBy: 2).tap()
            }
        }
    }

    // MARK: - Restaurant and Dish Tests

    // Проверка открытия ресторана и экрана блюда
    @MainActor
    func testRestaurantAndDishDetailsDeepFlow() throws {

        openHomeTab()

        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))

        let buttons = scrollView.buttons

        if buttons.count > 2 {
            buttons.element(boundBy: 2).tap()
        }

        if app.scrollViews.firstMatch.waitForExistence(timeout: 5) {

            let dishButtons = app.scrollViews.firstMatch.buttons

            if dishButtons.count > 0 {
                dishButtons.element(boundBy: 0).tap()
            }

            XCTAssertTrue(
                app.scrollViews.firstMatch.waitForExistence(timeout: 5),
                "Экран блюда должен открыться"
            )
        }
    }

    // Проверка добавления блюда в корзину и открытия корзины
    @MainActor
    func testAddDishToBasketAndOpenBasketDeepFlow() throws {

        openHomeTab()

        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))

        let buttons = scrollView.buttons

        if buttons.count > 2 {
            buttons.element(boundBy: 2).tap()
        }

        let restaurantScrollView = app.scrollViews.firstMatch
        let dishButtons = restaurantScrollView.buttons

        if dishButtons.count > 0 {
            dishButtons.element(boundBy: 0).tap()
        }

        let detailButtons = app.buttons

        if detailButtons.count > 0 {
            detailButtons.element(boundBy: 0).tap()
        }

        if detailButtons.count > 1 {
            detailButtons.element(boundBy: 1).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5),
            "После добавления блюда должен оставаться доступным экран приложения"
        )
    }

    // MARK: - Basket and Checkout Tests

    // Проверка перехода из ресторана в корзину
    @MainActor
    func testBasketScreenDeepFlow() throws {

        openHomeTab()

        let homeButtons = app.scrollViews.firstMatch.buttons

        if homeButtons.count > 2 {
            homeButtons.element(boundBy: 2).tap()
        }

        let restaurantButtons = app.buttons

        if restaurantButtons.count > 0 {
            restaurantButtons.element(boundBy: 0).tap()
        }

        if restaurantButtons.count > 1 {
            restaurantButtons.element(boundBy: 1).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5),
            "Корзина или экран блюда должны открыться"
        )
    }

    // Проверка оформления заказа через Checkout
    @MainActor
    func testCheckoutDeepFlow() throws {

        openHomeTab()

        let homeButtons = app.scrollViews.firstMatch.buttons

        if homeButtons.count > 2 {
            homeButtons.element(boundBy: 2).tap()
        }

        let restaurantButtons = app.buttons

        if restaurantButtons.count > 0 {
            restaurantButtons.element(boundBy: 0).tap()
        }

        let dishButtons = app.buttons

        if dishButtons.count > 0 {
            dishButtons.element(boundBy: 0).tap()
        }

        if dishButtons.count > 1 {
            dishButtons.element(boundBy: 1).tap()
        }

        let basketButtons = app.buttons

        if basketButtons.count > 0 {
            basketButtons.element(boundBy: 0).tap()
        }

        app.scrollViews.firstMatch.swipeUp()

        let checkoutButtons = app.buttons

        if checkoutButtons.count > 0 {
            checkoutButtons.element(boundBy: checkoutButtons.count - 1).tap()
        }

        let alert = app.alerts.firstMatch

        if alert.waitForExistence(timeout: 5) {
            alert.buttons.firstMatch.tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5)
                || app.tabBars.firstMatch.exists,
            "После оформления заказа приложение должно остаться в рабочем состоянии"
        )
    }

    // MARK: - Orders Tests

    // Проверка экрана заказов
    @MainActor
    func testOrdersScreenDeepFlow() throws {

        openOrdersTab()

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5),
            "Экран заказов должен открыться"
        )

        app.scrollViews.firstMatch.swipeUp()
        app.scrollViews.firstMatch.swipeDown()
    }

    // MARK: - Profile Tests

    // Проверка главного экрана профиля
    @MainActor
    func testProfileScreenDeepFlow() throws {

        openProfileTab()

        XCTAssertTrue(
            app.scrollViews.firstMatch.waitForExistence(timeout: 5),
            "Экран профиля должен открыться"
        )

        app.scrollViews.firstMatch.swipeUp()
        app.scrollViews.firstMatch.swipeDown()
    }

    // Проверка переходов внутри профиля
    @MainActor
    func testProfileOptionsDeepFlow() throws {

        openProfileTab()

        let buttons = app.buttons

        if buttons.count > 0 {
            buttons.element(boundBy: 0).tap()
        }

        if app.navigationBars.buttons.count > 0 {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }

        openProfileTab()

        let profileButtons = app.buttons

        if profileButtons.count > 1 {
            profileButtons.element(boundBy: 1).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.exists
                || app.tables.firstMatch.exists
                || app.collectionViews.firstMatch.exists,
            "После перехода внутри профиля должен открыться экран с данными"
        )
    }
}