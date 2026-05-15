//
//  EATSITApp.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

@main
struct EATSITApp: App {

    // MARK: - Properties

    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var orderViewModel = OrderViewModel()
    @StateObject private var localizationManager = LocalizationManager()

    // MARK: - Body

    var body: some Scene {

        WindowGroup {

            ContentView()
                .environmentObject(cartViewModel)
                .environmentObject(orderViewModel)
                .environmentObject(localizationManager)
                .environment(\.locale, Locale(identifier: localizationManager.selectedLanguage.rawValue))
        }
    }
}
