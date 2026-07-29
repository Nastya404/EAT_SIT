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
    @StateObject private var authViewModel = AuthViewModel()

    // MARK: - Body

    var body: some Scene {

        WindowGroup {

            Group {

                if authViewModel.isLoggedIn {
                    ContentView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(cartViewModel)
            .environmentObject(orderViewModel)
            .environmentObject(localizationManager)
            .environmentObject(authViewModel)
            .environment(\.locale, Locale(identifier: localizationManager.selectedLanguage.rawValue))
        }
    }
}
