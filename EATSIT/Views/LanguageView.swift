//
//  LanguageView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct LanguageView: View {

    // MARK: - Properties

    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                headerView
                languagesView
            }
            .padding(20)
        }
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Header View

    private var headerView: some View {

        HStack {

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(width: 52, height: 52)
                    .background(Color.white)
                    .clipShape(Circle())
            }

            Spacer()

            Text("language.title")
                .font(.title)
                .fontWeight(.bold)

            Spacer()

            Color.clear
                .frame(width: 52, height: 52)
        }
    }

    // MARK: - Languages View

    private var languagesView: some View {

        VStack(spacing: 0) {

            ForEach(AppLanguage.allCases) { language in

                languageRow(language)

                if language.id != AppLanguage.allCases.last?.id {
                    Divider()
                        .padding(.leading, 70)
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 26))
    }

    // MARK: - Language Row

    private func languageRow(_ language: AppLanguage) -> some View {

        Button {

            localizationManager.selectedLanguage = language

        } label: {

            HStack(spacing: 16) {

                Text(language.flag)
                    .font(.largeTitle)
                    .frame(width: 44, height: 44)

                Text(language.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Spacer()

                if localizationManager.selectedLanguage == language {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.orange)
                }
            }
            .padding(20)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        LanguageView()
            .environmentObject(LocalizationManager())
    }
}
