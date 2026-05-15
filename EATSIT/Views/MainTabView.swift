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
                    Text("tab.home")
                }

            OrdersView()
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("tab.orders")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("tab.profile")
                }
        }
        .tint(.orange)
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
}
