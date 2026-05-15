//
//  ProfileOptionRowView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct ProfileOptionRowView: View {

    // MARK: - Properties

    let option: ProfileOption

    // MARK: - Body

    var body: some View {

        HStack(spacing: 16) {

            iconView
            titleView

            Spacer()

            chevronView
        }
        .padding(20)
    }

    // MARK: - Icon View

    private var iconView: some View {

        Image(systemName: option.iconName)
            .font(.title3)
            .foregroundStyle(.orange)
            .frame(width: 44, height: 44)
            .background(Color.orange.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Title View

    private var titleView: some View {

        Text(option.title)
            .font(.headline)
    }

    // MARK: - Chevron View

    private var chevronView: some View {

        Image(systemName: "chevron.right")
            .font(.caption)
            .foregroundStyle(.gray)
    }
}

// MARK: - Preview

#Preview {

    ProfileOptionRowView(
        option: MockData.profileOptions[0]
    )
}
