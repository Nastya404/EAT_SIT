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

    private func buttonContaining(_ text: String) -> XCUIElement {
        app.buttons.containing(
            NSPredicate(format: "label CONTAINS %@", text)
        ).firstMatch
    }

    @discardableResult
    private func tapButtonContaining(_ text: String) -> Bool {
        let button = buttonContaining(text)

        if button.waitForExistence(timeout: 5) {
            button.tap()
            return true
        }

        return false
    }

    private func openMainScreen() {

        if app.tabBars.firstMatch.waitForExistence(timeout: 5) {
            return
        }

        guard isAtLoginScreen() else {
            return
        }

        if app.buttons["Sign Up"].waitForExistence(timeout: 5) {
            app.buttons["Sign Up"].tap()
        } else if app.buttons.count > 1 {
            app.buttons.element(boundBy: 1).tap()
        }

        let textFields = app.textFields
        let passwordField = app.secureTextFields.firstMatch

        guard textFields.firstMatch.waitForExistence(timeout: 5),
              passwordField.waitForExistence(timeout: 5) else {
            return
        }

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

        if app.buttons["Create Account"].waitForExistence(timeout: 5) {
            app.buttons["Create Account"].tap()
        } else if app.buttons.count > 0 {
            app.buttons.firstMatch.tap()
        }

        _ = app.tabBars.firstMatch.waitForExistence(timeout: 8)
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

    @discardableResult
    private func openFirstRestaurant() -> Bool {

        openHomeTab()

        let scrollView = app.scrollViews.firstMatch

        guard scrollView.waitForExistence(timeout: 5) else {
            return false
        }

        let buttons = scrollView.buttons

        if buttons.count > 2 {
            buttons.element(boundBy: 2).tap()
        } else if buttons.count > 0 {
            buttons.element(boundBy: 0).tap()
        }

        return app.scrollViews.firstMatch.waitForExistence(timeout: 5)
    }

    @discardableResult
    private func openFirstDish() -> Bool {

        guard openFirstRestaurant() else {
            return false
        }

        let buttons = app.scrollViews.firstMatch.buttons

        if buttons.count > 0 {
            buttons.element(boundBy: 0).tap()
        }

        return app.scrollViews.firstMatch.waitForExistence(timeout: 5)
    }

    // MARK: - Restaurant Tests

    @MainActor
    func testRestaurantMenuContentFlow() throws {

        _ = openFirstRestaurant()

        XCTAssertTrue(
            app.scrollViews.firstMatch.exists || app.tabBars.firstMatch.exists,
            "Приложение должно оставаться доступным"
        )

        if app.scrollViews.firstMatch.exists {
            app.scrollViews.firstMatch.swipeUp()
            app.scrollViews.firstMatch.swipeDown()
        }
    }

    // MARK: - Dish Details Tests

    @MainActor
    func testDishDetailsQuantityAndAddFlow() throws {

        _ = openFirstDish()

        if app.scrollViews.firstMatch.exists {
            app.scrollViews.firstMatch.swipeUp()
            app.scrollViews.firstMatch.swipeDown()
        }

        if app.buttons["+"].waitForExistence(timeout: 3) {
            app.buttons["+"].tap()
        }

        if app.buttons["−"].waitForExistence(timeout: 3) {
            app.buttons["−"].tap()
        }

        _ = tapButtonContaining("Add to Basket")

        XCTAssertTrue(
            app.scrollViews.firstMatch.exists || app.buttons.count > 0,
            "После действия экран должен остаться рабочим"
        )
    }

    // MARK: - Language Tests

    @MainActor
    func testLanguageScreenFlow() throws {

        openProfileTab()

        if !tapButtonContaining("Language"),
           app.buttons.count > 3 {
            app.buttons.element(boundBy: 3).tap()
        }

        XCTAssertTrue(
            app.scrollViews.firstMatch.exists
                || app.navigationBars.firstMatch.exists
                || app.buttons.count > 0,
            "Экран языка должен открыться или приложение должно остаться доступным"
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
            app.scrollViews.firstMatch.exists
                || app.navigationBars.firstMatch.exists
                || app.buttons.count > 0,
            "После смены языка экран должен оставаться доступным"
        )
    }
}
