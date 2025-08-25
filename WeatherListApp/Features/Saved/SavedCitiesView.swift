//
//  SavedCitiesView.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import SwiftUI

struct SavedCitiesView: View {
    @EnvironmentObject var container: AppContainer
    @StateObject private var vm: SavedCitiesViewModel
    
    init() {
        _vm = StateObject(
            wrappedValue: SavedCitiesViewModel(
                fetchWeather: AppContainer().fetchWeather,
                weatherRepo: AppContainer().weatherRepo
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !container.connectivity.isOnline {
                OfflineBanner(text: "Offline mode • showing cached weather")
            }
            List {
                ForEach(vm.items, id: \.0.id) { (city, weather) in
                    NavigationLink(value: city) {
                        WeatherRow(city: city, weather: weather)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            container.removeCity(id: city.id) // 🔑 updates instantly
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .refreshable {
                await vm.refresh(container: container) // manual pull-to-refresh
            }
            .navigationDestination(for: City.self) { city in
                WeatherDetailsView(city: city)
            }
        }
        .navigationTitle("Saved Cities")
        .onAppear {
            vm.bind(to: container)               // keep listening to savedCities
            Task { await vm.refresh(container: container) } // 🔑 auto-refresh on appear
        }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK", role: .cancel) { vm.errorMessage = nil }
        } message: { Text(vm.errorMessage ?? "") }
    }
}
