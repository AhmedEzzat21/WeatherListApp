//
//  RootView.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import SwiftUI

enum TabSelection: Hashable {
    case saved
    case search
}

struct RootView: View {
    @EnvironmentObject var container: AppContainer
    @State private var selection: TabSelection = .saved

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                SavedCitiesView()
            }
            .tabItem { Label("Saved", systemImage: "star.fill") }
            .tag(TabSelection.saved)

            NavigationStack {
                SearchView(tabSelection: $selection) // 🔑 pass binding
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            .tag(TabSelection.search)
        }
    }
}
