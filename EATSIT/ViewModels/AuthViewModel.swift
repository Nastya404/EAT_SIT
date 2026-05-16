//
//  AuthViewModel.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 17.05.2026.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {

    // MARK: - Properties

    private let userKey = "savedUser"
    private let loginKey = "isLoggedIn"

    // MARK: - Published Properties

    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage = ""

    // MARK: - Initialization

    init() {
        loadUser()
        isLoggedIn = UserDefaults.standard.bool(forKey: loginKey)
    }

    // MARK: - Methods

    func register(
        name: String,
        email: String,
        phone: String,
        password: String
    ) {

        guard !name.isEmpty,
              !email.isEmpty,
              !phone.isEmpty,
              !password.isEmpty else {
            errorMessage = "auth.error.emptyFields"
            return
        }

        let user = User(
            name: name,
            email: email,
            phone: phone,
            password: password
        )

        saveUser(user)
        currentUser = user
        isLoggedIn = true
        UserDefaults.standard.set(true, forKey: loginKey)
        errorMessage = ""
    }

    func login(email: String, password: String) {

        guard let currentUser else {
            errorMessage = "auth.error.noUser"
            return
        }

        guard currentUser.email == email,
              currentUser.password == password else {
            errorMessage = "auth.error.invalidCredentials"
            return
        }

        isLoggedIn = true
        UserDefaults.standard.set(true, forKey: loginKey)
        errorMessage = ""
    }

    func logout() {

        isLoggedIn = false
        UserDefaults.standard.set(false, forKey: loginKey)
    }

    private func saveUser(_ user: User) {

        guard let data = try? JSONEncoder().encode(user) else {
            return
        }

        UserDefaults.standard.set(data, forKey: userKey)
    }

    private func loadUser() {

        guard let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return
        }

        currentUser = user
    }
}
