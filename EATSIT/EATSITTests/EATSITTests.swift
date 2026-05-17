//
//  EATSITTests.swift
//  EATSITTests
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import XCTest
@testable import EATSIT

final class EATSITTests: XCTestCase {
    
    // Менеджеры и ViewModels для тестирования
    var cartViewModel: CartViewModel!
    var authViewModel: AuthViewModel!
    var localizationManager: LocalizationManager!
    
    // Константы ключей UserDefaults для очистки изоляции тестов
    private let languageKey = "selectedLanguage"
    private let userKey = "savedUser"
    private let loginKey = "isLoggedIn"
    
    // Шаблонные тестовые данные
    var sampleDish1: Dish!
    var sampleDish2: Dish!
    var toppingCheese: DishCustomization!
    var toppingJalapeno: DishCustomization!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Очищаем UserDefaults перед каждым тестом для обеспечения чистой среды тестирования
        UserDefaults.standard.removeObject(forKey: languageKey)
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: loginKey)
        UserDefaults.standard.synchronize()
        
        // Инициализируем тестируемые компоненты
        cartViewModel = CartViewModel()
        authViewModel = AuthViewModel()
        localizationManager = LocalizationManager()
        
        // Создаем тестовые сущности
        sampleDish1 = Dish(id: "d1", restaurantId: "r1", name: "Пицца Маргарита", description: "Вкусная пицца", price: 12.5, imageName: "pizza", category: "Пицца", restaurantName: "Додо Пицца")
        sampleDish2 = Dish(id: "d2", restaurantId: "r1", name: "Бургер Классик", description: "Сочная котлета", price: 8.0, imageName: "burger", category: "Бургеры", restaurantName: "Додо Пицца")
        
        toppingCheese = DishCustomization(name: "Сырный бортик", price: 2.5)
        toppingJalapeno = DishCustomization(name: "Халапеньо", price: 1.5)
    }

    override func tearDownWithError() throws {
        // Зануляем объекты для предотвращения утечек памяти между тестами
        cartViewModel = nil
        authViewModel = nil
        localizationManager = nil
        
        sampleDish1 = nil
        sampleDish2 = nil
        toppingCheese = nil
        toppingJalapeno = nil
        
        // Повторная зачистка хранилища данных
        UserDefaults.standard.removeObject(forKey: languageKey)
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: loginKey)
        UserDefaults.standard.synchronize()
        
        try super.tearDownWithError()
    }

    // MARK: - ГРУППА 1: Тестирование CartItem и математических вычислений цен

    // Тест 1: Расчет стоимости позиции в корзине без дополнительных топпингов
    func testCartItemPriceWithoutToppings() {
        let quantity = 3
        let item = CartItem(dish: sampleDish1, quantity: quantity, selectedToppings: [])
        
        // Ожидаемо: 12.5 * 3 = 37.5
        XCTAssertEqual(item.totalPrice, 37.5, "Математика подсчета стоимости CartItem без топпингов нарушена")
    }

    // Тест 2: Расчет стоимости позиции в корзине с топпингами (единичное количество)
    func testCartItemPriceWithToppingsSingleQuantity() {
        let item = CartItem(dish: sampleDish1, quantity: 1, selectedToppings: [toppingCheese, toppingJalapeno])
        
        // Ожидаемо: (12.5 + 2.5 + 1.5) * 1 = 16.5
        XCTAssertEqual(item.totalPrice, 16.5, "Стоимость топпингов не приплюсовалась к базовой цене блюда")
    }

    // Тест 3: Расчет стоимости позиции при множественном количестве и нескольких топпингах
    func testCartItemPriceWithToppingsMultipleQuantity() {
        let item = CartItem(dish: sampleDish2, quantity: 2, selectedToppings: [toppingCheese])
        
        // Ожидаемо: (8.0 + 2.5) * 2 = 21.0
        XCTAssertEqual(item.totalPrice, 21.0, "Ошибка подсчета цены при комбинации топпингов и количества > 1")
    }

    // MARK: - ГРУППА 2: Тестирование CartViewModel (Управление Корзиной)

    // Тест 4: Проверка начального состояния корзины
    func testCartInitiallyEmpty() {
        XCTAssertTrue(cartViewModel.items.isEmpty, "Новая корзина должна быть строго пустой")
        XCTAssertEqual(cartViewModel.totalPrice, 0.0, "Начальная сумма в пустой корзине должна быть равна 0")
    }

    // Тест 5: Добавление элементов в корзину и пересчет общего баланса
    func testCartAddItemAndTotalPriceCalculation() {
        let item1 = CartItem(dish: sampleDish1, quantity: 1, selectedToppings: [])
        let item2 = CartItem(dish: sampleDish2, quantity: 2, selectedToppings: [toppingJalapeno]) // (8.0 + 1.5) * 2 = 19.0
        
        cartViewModel.addItem(item1)
        cartViewModel.addItem(item2)
        
        XCTAssertEqual(cartViewModel.items.count, 2, "Элементы не добавились в массив items корзины")
        // Итого: 12.5 + 19.0 = 31.5
        XCTAssertEqual(cartViewModel.totalPrice, 31.5, "Общая сумма корзины totalPrice посчитана неверно")
    }

    // Тест 6: Удаление конкретного элемента из корзины
    func testCartRemoveItem() {
        let item = CartItem(dish: sampleDish1, quantity: 1, selectedToppings: [])
        cartViewModel.addItem(item)
        XCTAssertEqual(cartViewModel.items.count, 1)
        
        cartViewModel.removeItem(item)
        
        XCTAssertTrue(cartViewModel.items.isEmpty, "Элемент не удалился из корзины по его уникальному ID")
        XCTAssertEqual(cartViewModel.totalPrice, 0.0)
    }

    // Тест 7: Увеличение количества существующей позиции в корзине
    func testCartIncreaseItemQuantity() {
        let item = CartItem(dish: sampleDish1, quantity: 1, selectedToppings: [])
        cartViewModel.addItem(item)
        
        // Так как ID генерируется внутри структуры, берем добавленный объект из вьюмодели
        guard let addedItem = cartViewModel.items.first else { return XCTFail("Элемент не найден") }
        cartViewModel.increaseQuantity(for: addedItem)
        
        XCTAssertEqual(cartViewModel.items.first?.quantity, 2, "Метод increaseQuantity не увеличил количество")
        XCTAssertEqual(cartViewModel.totalPrice, 25.0, "Цена корзины не пересчиталась после инкремента количества")
    }

    // Тест 8: Уменьшение количества существующей позиции в корзине
    func testCartDecreaseItemQuantity() {
        let item = CartItem(dish: sampleDish1, quantity: 3, selectedToppings: [])
        cartViewModel.addItem(item)
        
        guard let addedItem = cartViewModel.items.first else { return XCTFail("Элемент не найден") }
        cartViewModel.decreaseQuantity(for: addedItem)
        
        XCTAssertEqual(cartViewModel.items.first?.quantity, 2, "Метод decreaseQuantity не уменьшил количество")
        XCTAssertEqual(cartViewModel.totalPrice, 25.0)
    }

    // Тест 9: Граничное состояние: уменьшение количества при значении = 1 не должно срабатывать
    func testCartDecreaseQuantityBoundaryCondition() {
        let item = CartItem(dish: sampleDish1, quantity: 1, selectedToppings: [])
        cartViewModel.addItem(item)
        
        guard let addedItem = cartViewModel.items.first else { return XCTFail("Элемент не найден") }
        cartViewModel.decreaseQuantity(for: addedItem)
        
        // Количество должно остаться равным 1, элемент не должен удаляться или уходить в 0
        XCTAssertEqual(cartViewModel.items.first?.quantity, 1, "Количество опустилось ниже 1, что нарушает бизнес-логику")
    }

    // Тест 10: Полная очистка корзины (Clear Cart)
    func testCartClear() {
        cartViewModel.addItem(CartItem(dish: sampleDish1, quantity: 1, selectedToppings: []))
        cartViewModel.addItem(CartItem(dish: sampleDish2, quantity: 5, selectedToppings: []))
        XCTAssertEqual(cartViewModel.items.count, 2)
        
        cartViewModel.clearCart()
        
        XCTAssertTrue(cartViewModel.items.isEmpty, "Метод clearCart() оставил элементы в корзине")
        XCTAssertEqual(cartViewModel.totalPrice, 0.0)
    }

    // MARK: - ГРУППА 3: Тестирование AuthViewModel (Авторизация и Валидация)

    // Тест 11: Попытка регистрации пользователя с пустыми полями
    func testAuthRegistrationWithEmptyFieldsFails() {
        authViewModel.register(name: "", email: "", phone: "", password: "")
        
        XCTAssertFalse(authViewModel.isLoggedIn, "Пользователь вошел в систему вопреки пустым полям")
        XCTAssertEqual(authViewModel.errorMessage, "auth.error.emptyFields", "Не сработал локализованный ключ ошибки пустых полей")
    }

    // Те.ст 12: Успешный цикл регистрации пользователя
    func testAuthSuccessfulRegistrationAndDataPersistence() {
        let name = "Полина Богуш"
        let email = "polina@eatsit.by"
        let phone = "+375291234567"
        let password = "super_secure_password"
        
        authViewModel.register(name: name, email: email, phone: phone, password: password)
        
        XCTAssertTrue(authViewModel.isLoggedIn, "Флаг isLoggedIn не переключился в true после успешной регистрации")
        XCTAssertNotNil(authViewModel.currentUser, "Текущий объект пользователя currentUser остался nil")
        XCTAssertEqual(authViewModel.currentUser?.name, name)
        XCTAssertEqual(authViewModel.errorMessage, "")
        
        // Проверяем, что данные реально записались в постоянную память UserDefaults
        let savedIsLoggedIn = UserDefaults.standard.bool(forKey: loginKey)
        XCTAssertTrue(savedIsLoggedIn, "Состояние входа не продублировалось в UserDefaults")
    }

    // Тест 13: Вход с неверным паролем / данными
    func testAuthLoginWithInvalidCredentials() {
        // Создаем пользователя в системе
        authViewModel.register(name: "User", email: "test@test.com", phone: "123", password: "correct_password")
        authViewModel.logout() // Сбрасываем текущую сессию
        
        // Пробуем зайти с неверным паролем
        authViewModel.login(email: "test@test.com", password: "wrong_password")
        
        XCTAssertFalse(authViewModel.isLoggedIn, "Система пропустила неверный пароль")
        XCTAssertEqual(authViewModel.errorMessage, "auth.error.invalidCredentials")
    }

    // Тест 14: Попытка входа, когда в системе вообще нет зарегистрированных пользователей
    func testAuthLoginWhenNoUserExists() {
        authViewModel.login(email: "any@mail.com", password: "any")
        
        XCTAssertFalse(authViewModel.isLoggedIn)
        XCTAssertEqual(authViewModel.errorMessage, "auth.error.noUser")
    }

    // MARK: - ГРУППА 4: Тестирование Локализации (LocalizationManager & Enums)

    // Тест 15: Изменение языка сохраняет данные в UserDefaults и обновляет состояние
    func testLocalizationLanguageChange() {
        XCTAssertEqual(localizationManager.selectedLanguage, .english, "По умолчанию должен быть английский язык")
        
        // Меняем язык на польский
        localizationManager.selectedLanguage = .polish
        
        XCTAssertEqual(localizationManager.selectedLanguage, .polish)
        let savedLangRaw = UserDefaults.standard.string(forKey: languageKey)
        XCTAssertEqual(savedLangRaw, "pl", "Новый язык не записался в UserDefaults внутри didSet")
    }

    // Тест 16: Проверка свойств перечисления AppLanguage (Флаги и Названия)
    func testAppLanguageEnumProperties() {
        let ru = AppLanguage.russian
        XCTAssertEqual(ru.title, "Русский")
        XCTAssertEqual(ru.flag, "🇷🇺")
        
        let en = AppLanguage.english
        XCTAssertEqual(en.title, "English")
        XCTAssertEqual(en.flag, "🇬🇧")
    }
}
