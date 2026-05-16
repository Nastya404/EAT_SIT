//
//  LoginView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 17.05.2026.
//

import SwiftUI

struct LoginView: View {

    // MARK: - Properties

    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ZStack {

                Color(.systemGray6)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 28) {

                    Spacer()

                    titleView
                    fieldsView
                    errorView
                    loginButton
                    registerLink

                    Spacer()
                }
                .padding(28)
            }
        }
    }

    // MARK: - Title View

    private var titleView: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("auth.login.title")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("auth.login.subtitle")
                .foregroundStyle(.gray)
        }
    }

    // MARK: - Fields View

    private var fieldsView: some View {

        VStack(spacing: 16) {

            TextField("auth.email", text: $email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))

            SecureField("auth.password", text: $password)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    // MARK: - Error View

    private var errorView: some View {

        Group {

            if !authViewModel.errorMessage.isEmpty {

                Text(LocalizedStringKey(authViewModel.errorMessage))
                    .font(.subheadline)
                    .foregroundStyle(.red)
            }
        }
    }

    // MARK: - Login Button

    private var loginButton: some View {

        Button {

            authViewModel.login(
                email: email,
                password: password
            )

        } label: {

            HStack {

                Text("auth.login.button")
                Image(systemName: "arrow.right.square")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
    }

    // MARK: - Register Link

    private var registerLink: some View {

        HStack {

            Text("auth.login.noAccount")
                .foregroundStyle(.gray)

            NavigationLink {

                RegisterView()

            } label: {

                Text("auth.login.signUp")
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {

    LoginView()
        .environmentObject(AuthViewModel())
}
