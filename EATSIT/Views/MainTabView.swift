//
//  MainTabView.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import SwiftUI

struct MainTabView: View {

    // MARK: - Body

    var body: some View {

        TabView {

            HomeView()
                .tabItem {

                    Image(systemName: "house.fill")
                    Text("Home")
                }

            OrdersView()
                .tabItem {

                    Image(systemName: "list.clipboard.fill")
                    Text("Orders")
                }

            ProfileView()
                .tabItem {

                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .tint(.orange)
    }
}

// MARK: - Preview

#Preview {

    MainTabView()
}
