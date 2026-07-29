//
//  LocalizationManager.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI
import Combine

final class LocalizationManager: ObservableObject {

    // MARK: - Properties

    private let languageKey = "selectedLanguage"

    // MARK: - Published Properties

    @Published var selectedLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: languageKey)
        }
    }

    // MARK: - Initialization

    init() {
        let savedLanguage = UserDefaults.standard.string(forKey: languageKey)

        selectedLanguage = AppLanguage(rawValue: savedLanguage ?? "") ?? .english
    }
}
