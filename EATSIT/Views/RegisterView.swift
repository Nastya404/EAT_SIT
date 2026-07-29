//
//  RegisterView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 17.05.2026.
//

import SwiftUI

struct RegisterView: View {

    // MARK: - Properties

    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""

    // MARK: - Body

    var body: some View {

        ZStack {

            Color(.systemGray6)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                Spacer()

                titleView
                fieldsView
                errorView
                registerButton
                loginLink

                Spacer()
            }
            .padding(28)
        }
        .navigationBarBackButtonHidden(false)
    }

    // MARK: - Title View

    private var titleView: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("auth.register.title")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("auth.register.subtitle")
                .foregroundStyle(.gray)
        }
    }

    // MARK: - Fields View

    private var fieldsView: some View {

        VStack(spacing: 16) {

            TextField("auth.name", text: $name)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))

            TextField("auth.email", text: $email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))

            TextField("auth.phone", text: $phone)
                .keyboardType(.phonePad)
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

    // MARK: - Register Button

    private var registerButton: some View {

        Button {

            authViewModel.register(
                name: name,
                email: email,
                phone: phone,
                password: password
            )

        } label: {

            HStack {

                Text("auth.register.button")
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

    // MARK: - Login Link

    private var loginLink: some View {

        HStack {

            Text("auth.register.hasAccount")
                .foregroundStyle(.gray)

            Button {

                dismiss()

            } label: {

                Text("auth.register.signIn")
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
