//
//  AppLanguage.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {

    // MARK: - Cases

    case english = "en"
    case russian = "ru"
    case polish = "pl"

    // MARK: - Properties

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .english:
            return "English"
        case .russian:
            return "Русский"
        case .polish:
            return "Polski"
        }
    }

    var flag: String {
        switch self {
        case .english:
            return "🇬🇧"
        case .russian:
            return "🇷🇺"
        case .polish:
            return "🇵🇱"
        }
    }
}
