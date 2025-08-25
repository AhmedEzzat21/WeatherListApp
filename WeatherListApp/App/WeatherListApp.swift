//
//  WeatherListApp.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import SwiftUI

@main
struct WeatherListApp: App {
    @StateObject private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(container)
        }
    }
}
