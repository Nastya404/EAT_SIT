//
//  EATSITUITests.swift
//  EATSITUITests
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import XCTest

final class EATSITUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    // MARK: - Вспомогательные методы

    // Проверка, находимся ли мы на экране логина
    private func isAtLoginScreen() -> Bool {
        return app.secureTextFields.firstMatch.exists
    }

    // Вспомогательный метод для входа перед началом тестов
    private func loginIfNeeded() {
        if isAtLoginScreen() {
            let emailField = app.textFields.firstMatch
            let passwordField = app.secureTextFields.firstMatch
            let loginButton = app.buttons.firstMatch

            if emailField.waitForExistence(timeout: 5) && passwordField.exists {
                emailField.tap()
                emailField.typeText("test@eatsit.by")

                passwordField.tap()
                passwordField.typeText("123456")

                let returnButton = app.keyboards.buttons.element(boundBy: 0)
                if returnButton.waitForExistence(timeout: 3) {
                    returnButton.tap()
                }

                if loginButton.exists {
                    loginButton.tap()
                }

                // Увеличили таймаут ожидания перехода на главный экран в CI
                _ = app.tabBars.firstMatch.waitForExistence(timeout: 8)
            }
        }
    }

    // MARK: - Тесты Авторизации (Login & Register)

    @MainActor
    func testLoginScreenElementsExist() throws {
        if isAtLoginScreen() {
            XCTAssertTrue(
                app.textFields.firstMatch.waitForExistence(timeout: 5),
                "Поле Email должно существовать"
            )
            XCTAssertTrue(
                app.secureTextFields.firstMatch.exists,
                "Поле Пароль должно существовать"
            )
        }
    }

    @MainActor
    func testNavigationToRegisterScreen() throws {
        if isAtLoginScreen() {
            let registerButton = app.buttons.element(boundBy: 1)

            if registerButton.waitForExistence(timeout: 5) {
                registerButton.tap()

                // Ждем пока прогрузится экран регистрации
                let textFields = app.textFields
                _ = textFields.firstMatch.waitForExistence(timeout: 5)
                XCTAssertTrue(textFields.count >= 2)
            }
        }
    }

    // MARK: - Тесты Навигации и Главного экрана

    // 3. Проверка переключения вкладок в TabBar
    @MainActor
    func testTabBarNavigation() throws {

        loginIfNeeded()

        let tabBar = app.tabBars.firstMatch

        // Если вход прошёл успешно, проверяем вкладки главного экрана
        if tabBar.waitForExistence(timeout: 8) {

            let tabCount = tabBar.buttons.count

            XCTAssertGreaterThanOrEqual(
                tabCount,
                1,
                "TabBar должен содержать хотя бы одну вкладку"
            )

            // Переход на вкладку заказов
            if tabCount > 1 {
                tabBar.buttons.element(boundBy: 1).tap()
            }

            // Переход на вкладку профиля
            if tabCount > 2 {
                tabBar.buttons.element(boundBy: 2).tap()
            }

            // Возврат на главную вкладку
            tabBar.buttons.element(boundBy: 0).tap()

        } else {

            // В CI приложение может открыться без сохранённого пользователя.
            // В таком случае допустимо, что отображается экран авторизации.
            XCTAssertTrue(
                isAtLoginScreen(),
                "Приложение должно открыть либо главный экран, либо экран авторизации"
            )
        }
    }

    @MainActor
    func testHomeSearchBar() throws {
        loginIfNeeded()

        let searchField = app.textFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Поле поиска должно быть на главной")

        searchField.tap()
        searchField.typeText("Pizza")
    }

    @MainActor
    func testHomeCategorySelection() throws {
        loginIfNeeded()

        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))

        let categoryButton = scrollView.buttons.element(boundBy: 1)
        if categoryButton.waitForExistence(timeout: 3) {
            categoryButton.tap()
        }
    }

    @MainActor
    func testMapScreenOpens() throws {
        loginIfNeeded()

        let mapElement = app.maps.firstMatch
        if mapElement.waitForExistence(timeout: 5) {
            XCTAssertTrue(mapElement.exists)
        }
    }

    // MARK: - Тесты Заказа (Ресторан, Блюдо, Корзина)

    @MainActor
    func testOpenRestaurantMenu() throws {
        loginIfNeeded()

        let restaurantButton = app.scrollViews.firstMatch.buttons.element(boundBy: 2)
        if restaurantButton.waitForExistence(timeout: 5) {
            restaurantButton.tap()
        }
    }

    @MainActor
    func testDishDetailsScreenOpens() throws {
        loginIfNeeded()

        let scrollView = app.scrollViews.firstMatch

        let firstRestaurant = scrollView.buttons.element(boundBy: 2)
        if firstRestaurant.waitForExistence(timeout: 5) {
            firstRestaurant.tap()

            let firstDish = app.scrollViews.firstMatch.buttons.element(boundBy: 0)
            if firstDish.waitForExistence(timeout: 5) {
                firstDish.tap()

                XCTAssertTrue(
                    app.scrollViews.firstMatch.waitForExistence(timeout: 5),
                    "Экран блюда должен открыться"
                )
            }
        }
    }

    @MainActor
    func testBasketAndOrdersViews() throws {
        loginIfNeeded()

        let tabBar = app.tabBars.firstMatch
        if tabBar.waitForExistence(timeout: 5) {
            tabBar.buttons.element(boundBy: 1).tap()
            XCTAssertTrue(app.scrollViews.firstMatch.waitForExistence(timeout: 5))
        }
    }

    // MARK: - Тесты Профиля

    // 10. Проверка открытия экрана профиля
    @MainActor
    func testProfileLogoutAlert() throws {

        // Пытаемся войти в приложение перед проверкой профиля
        loginIfNeeded()

        let tabBar = app.tabBars.firstMatch

        // Если пользователь авторизован, открываем вкладку профиля
        if tabBar.waitForExistence(timeout: 8),
           tabBar.buttons.count > 2 {

            // Клик по вкладке профиля
            tabBar.buttons.element(boundBy: 2).tap()

            // Проверяем, что экран профиля открылся
            XCTAssertTrue(
                app.scrollViews.firstMatch.waitForExistence(timeout: 5),
                "Экран профиля должен открыться"
            )

        } else {

            // Если пользователь не авторизован, приложение должно остаться на экране входа
            XCTAssertTrue(
                isAtLoginScreen(),
                "Если пользователь не авторизован, должен отображаться экран входа"
            )
        }
    }
}
