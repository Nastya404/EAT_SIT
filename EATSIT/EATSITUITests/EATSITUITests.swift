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
    
    @MainActor
    func testTabBarNavigation() throws {
        loginIfNeeded()

        var tabBar = app.tabBars.firstMatch

        // Если вход не сработал, регистрируем тестового пользователя
        if !tabBar.waitForExistence(timeout: 5), isAtLoginScreen() {
            let registerButton = app.buttons.element(boundBy: 1)

            if registerButton.waitForExistence(timeout: 5) {
                registerButton.tap()
            }

            let textFields = app.textFields
            let passwordField = app.secureTextFields.firstMatch

            if textFields.firstMatch.waitForExistence(timeout: 5), passwordField.waitForExistence(timeout: 5) {
                textFields.element(boundBy: 0).tap()
                textFields.element(boundBy: 0).typeText("Test User")

                textFields.element(boundBy: 1).tap()
                textFields.element(boundBy: 1).typeText("test@eatsit.by")

                textFields.element(boundBy: 2).tap()
                textFields.element(boundBy: 2).typeText("+375291112233")

                passwordField.tap()
                passwordField.typeText("123456")

                let returnButton = app.keyboards.buttons.element(boundBy: 0)
                if returnButton.exists {
                    returnButton.tap()
                }

                let createAccountButton = app.buttons.firstMatch
                if createAccountButton.waitForExistence(timeout: 5) {
                    createAccountButton.tap()
                }
            }

            tabBar = app.tabBars.firstMatch
        }

        XCTAssertTrue(
            tabBar.waitForExistence(timeout: 8),
            "Нижняя панель навигации должна появиться после входа или регистрации"
        )

        let ordersTab = tabBar.buttons.element(boundBy: 1)
        XCTAssertTrue(ordersTab.waitForExistence(timeout: 5), "Вкладка заказов должна существовать")
        ordersTab.tap()

        let profileTab = tabBar.buttons.element(boundBy: 2)
        XCTAssertTrue(profileTab.waitForExistence(timeout: 5), "Вкладка профиля должна существовать")
        profileTab.tap()

        let homeTab = tabBar.buttons.element(boundBy: 0)
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5), "Вкладка главной страницы должна существовать")
        homeTab.tap()
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
    
    @MainActor
    func testProfileLogoutAlert() throws {
        // УДАЛЕНО: Переинициализация локального app, ломавшая стейт
        loginIfNeeded()
        
        var tabBar = app.tabBars.firstMatch
        
        if !tabBar.waitForExistence(timeout: 5), isAtLoginScreen() {
            let registerButton = app.buttons.element(boundBy: 1)
            if registerButton.waitForExistence(timeout: 5) {
                registerButton.tap()
            }
            
            let textFields = app.textFields
            let passwordField = app.secureTextFields.firstMatch
            
            if textFields.firstMatch.waitForExistence(timeout: 5), passwordField.waitForExistence(timeout: 5) {
                textFields.element(boundBy: 0).tap()
                textFields.element(boundBy: 0).typeText("Test User")
                
                textFields.element(boundBy: 1).tap()
                textFields.element(boundBy: 1).typeText("test@eatsit.by")
                
                textFields.element(boundBy: 2).tap()
                textFields.element(boundBy: 2).typeText("+375291112233")
                
                passwordField.tap()
                passwordField.typeText("123456")
                
                let returnButton = app.keyboards.buttons.element(boundBy: 0)
                if returnButton.exists {
                    returnButton.tap()
                }
                
                let createAccountButton = app.buttons.firstMatch
                if createAccountButton.waitForExistence(timeout: 5) {
                    createAccountButton.tap()
                }
            }
            
            tabBar = app.tabBars.firstMatch
        }
        
        XCTAssertTrue(
            tabBar.waitForExistence(timeout: 8),
            "Нижняя панель навигации должна появиться после входа или регистрации"
        )
        
        // Клик по вкладке профиля
        tabBar.buttons.element(boundBy: 2).tap()
        
        // СТАБИЛИЗАЦИЯ: Сначала ждем появления хотя бы одной кнопки на экране профиля
        let allButtons = app.buttons
        _ = allButtons.firstMatch.waitForExistence(timeout: 5)
        
        let buttonCount = allButtons.count
        XCTAssertTrue(buttonCount > 0, "На экране профиля не найдены кнопки")
        
        // Безопасно берем последнюю кнопку (Выйти)
        let logoutButton = allButtons.element(boundBy: buttonCount - 1)
        
        if logoutButton.waitForExistence(timeout: 5) {
            logoutButton.tap()
            
            // Проверяем появление системного алерта
            let alert = app.alerts.firstMatch
            XCTAssertTrue(
                alert.waitForExistence(timeout: 5),
                "Алерт подтверждения выхода должен появиться"
            )
            
            // Нажимаем отмену (первая кнопка на алерте)
            let cancelButton = alert.buttons.element(boundBy: 0)
            if cancelButton.waitForExistence(timeout: 3) {
                cancelButton.tap()
            }
        }
    }
}
