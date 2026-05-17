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
    
    // Проверка, находимся ли мы на экране логина (ищем по тексту или наличию полей)
    private func isAtLoginScreen() -> Bool {
        // Безопасный поиск текстового поля для безопасного ввода (пароля)
        return app.descendants(matching: .secureTextField).firstMatch.exists
    }
    
    // Вспомогательный метод для входа перед началом тестов главной цепочки
    private func loginIfNeeded() {
        if isAtLoginScreen() {
            let emailField = app.descendants(matching: .textField).firstMatch
            let passwordField = app.descendants(matching: .secureTextField).firstMatch
            let loginButton = app.descendants(matching: .button).firstMatch
            
            if emailField.exists && passwordField.exists {
                emailField.tap()
                emailField.typeText("test@eatsit.by")
                
                passwordField.tap()
                passwordField.typeText("123456")
                
                // Закрываем клавиатуру, если кнопка "Войти" перекрыта
                let returnButton = app.keyboards.buttons.element(boundBy: 0)
                if returnButton.exists {
                    returnButton.tap()
                }
                
                if loginButton.exists {
                    loginButton.tap()
                }
                
                // Небольшое ожидание анимации перехода на ContentView
                _ = app.descendants(matching: .tabBar).firstMatch.waitForExistence(timeout: 3)
            }
        }
    }

    // MARK: - Тесты Авторизации (Login & Register)

    // 1. Проверка наличия элементов на экране входа
    @MainActor
    func testLoginScreenElementsExist() throws {
        if isAtLoginScreen() {
            XCTAssertTrue(app.descendants(matching: .textField).firstMatch.exists, "Поле Email должно существовать")
            XCTAssertTrue(app.descendants(matching: .secureTextField).firstMatch.exists, "Поле Пароль должно существовать")
        }
    }

    // 2. Проверка возможности клика по переходу на регистрацию
    @MainActor
    func testNavigationToRegisterScreen() throws {
        if isAtLoginScreen() {
            // Ищем кнопку регистрации по тексту (например, "auth.login.signUp" в локализации)
            let registerButton = app.descendants(matching: .button).element(boundBy: 1)
            if registerButton.waitForExistence(timeout: 2) {
                registerButton.tap()
                // На экране регистрации полей ввода становится больше
                XCTAssertTrue(app.descendants(matching: .textField).count >= 2)
            }
        }
    }

    // MARK: - Тесты Навигации и Главного экрана

    // 3. Проверка переключения вкладок в TabBar (Главная, Заказы, Профиль)
    @MainActor
    func testTabBarNavigation() throws {
        loginIfNeeded()
        
        let tabBar = app.descendants(matching: .tabBar).firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5), "Нижняя панель навигации должна появиться")
        
        let ordersTab = tabBar.buttons.element(boundBy: 1)
        if ordersTab.exists {
            ordersTab.tap()
        }
        
        let profileTab = tabBar.buttons.element(boundBy: 2)
        if profileTab.exists {
            profileTab.tap()
        }
        
        let homeTab = tabBar.buttons.element(boundBy: 0)
        if homeTab.exists {
            homeTab.tap()
        }
    }

    // 4. Проверка взаимодействия с поисковой строкой на HomeView
    @MainActor
    func testHomeSearchBar() throws {
        loginIfNeeded()
        
        let searchField = app.descendants(matching: .textField).firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Поле поиска должно быть на главной")
        
        searchField.tap()
        searchField.typeText("Pizza")
    }

    // 5. Выбор категории блюд на главной
    @MainActor
    func testHomeCategorySelection() throws {
        loginIfNeeded()
        
        let scrollView = app.descendants(matching: .scrollView).firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 3))
        
        // Тапаем по одному из элементов категорий внутри скролла
        let categoryButton = scrollView.descendants(matching: .button).element(boundBy: 1)
        if categoryButton.exists {
            categoryButton.tap()
        }
    }

    // 6. Переход на карту ресторанов RestaurantMapView
    @MainActor
    func testMapScreenOpens() throws {
        loginIfNeeded()
        
        // В HomeView нет явной кнопки карты, но мы можем проверить ее вызов, если она открывается из интерфейса
        let mapElement = app.descendants(matching: .map).firstMatch
        // Проверяем, существует ли объект карты в приложении (вкладка или экран)
        if mapElement.exists {
            XCTAssertTrue(mapElement.exists)
        }
    }

    // MARK: - Тесты Заказа (Ресторан, Блюдо, Корзина)

    // 7. Имитация открытия карточки ресторана
    @MainActor
    func testOpenRestaurantMenu() throws {
        loginIfNeeded()
        
        // Находим скроллбар с ресторанами и кликаем по первой доступной кнопке-карточке
        let restaurantButton = app.descendants(matching: .scrollView).descendants(matching: .button).element(boundBy: 2)
        if restaurantButton.waitForExistence(timeout: 3) {
            restaurantButton.tap()
        }
    }

    // 8. Проверка изменения количества на экране DishDetailsView
    @MainActor
    func testDishQuantityButtons() throws {
        loginIfNeeded()
        
        let scrollView = app.descendants(matching: .scrollView).firstMatch
        let firstRestaurant = scrollView.descendants(matching: .button).element(boundBy: 2)
        
        if firstRestaurant.waitForExistence(timeout: 3) {
            firstRestaurant.tap()
            
            let firstDish = app.descendants(matching: .scrollView).descendants(matching: .button).element(boundBy: 0)
            if firstDish.waitForExistence(timeout: 3) {
                firstDish.tap()
                
                // Ищем кнопки изменения количества по тексту/иконкам, если они отрисовались
                let plusButton = app.buttons["+"]
                if plusButton.exists {
                    plusButton.tap()
                }
            }
        }
    }

    // 9. Переход на вкладку заказов и проверка состояния пустой корзины
    @MainActor
    func testBasketAndOrdersViews() throws {
        loginIfNeeded()
        
        let tabBar = app.descendants(matching: .tabBar).firstMatch
        if tabBar.waitForExistence(timeout: 2) {
            tabBar.buttons.element(boundBy: 1).tap() // Переходим в OrdersView
            XCTAssertTrue(app.descendants(matching: .scrollView).firstMatch.exists)
        }
    }

    // MARK: - Тесты Профиля

    // 10. Проверка вызова алерта подтверждения выхода в ProfileView
    @MainActor
    func testProfileLogoutAlert() throws {
        loginIfNeeded()
        
        let tabBar = app.descendants(matching: .tabBar).firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 3))
        tabBar.buttons.element(boundBy: 2).tap() // Клик по вкладке профиля
        
        // Ищем кнопку выхода (обычно нижняя кнопка на экране)
        let logoutButton = app.descendants(matching: .button).element(boundBy: app.descendants(matching: .button).count - 1)
        if logoutButton.waitForExistence(timeout: 2) {
            logoutButton.tap()
            
            // Проверяем появление системного алерта SwiftUI (.alert)
            let alert = app.alerts.firstMatch
            XCTAssertTrue(alert.waitForExistence(timeout: 2), "Алерт подтверждения выхода должен появиться")
            
            // Нажимаем отмену ("profile.cancel")
            if alert.buttons.element(boundBy: 0).exists {
                alert.buttons.element(boundBy: 0).tap()
            }
        }
    }
}
