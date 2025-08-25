//
//  WeatherDetailsView.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import SwiftUI

struct WeatherDetailsView: View {
    @EnvironmentObject var container: AppContainer
    let city: City
    @StateObject private var vm: WeatherDetailsViewModel

    init(city: City) {
        self.city = city
        _vm = StateObject(wrappedValue: WeatherDetailsViewModel(
            city: city,
            fetch: AppContainer().fetchWeather,
            repo: AppContainer().weatherRepo
        ))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !container.connectivity.isOnline {
                OfflineBanner(text: "Offline • showing last cached data if available")
            }
            Group {
                if let w = vm.weather {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(city.name), \(city.country)")
                            .font(.largeTitle).bold()
                        Text("Updated: \(w.time.formatted(date: .abbreviated, time: .shortened))")
                            .font(.footnote).foregroundStyle(.secondary)
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text("\(Int(round(w.temperatureC)))")
                                .font(.system(size: 64, weight: .semibold))
                            Text("°C \(w.condition)")
                                .font(.title2)
                        }
                        Divider()
                        Grid(horizontalSpacing: 24, verticalSpacing: 12) {
                            GridRow {
                                Label("Wind Speed", systemImage: "wind")
                                Text("\(Int(round(w.windSpeed ?? 0))) km/h")
                            }
                            GridRow {
                                Label("Wind Direction", systemImage: "location.north.line")
                                Text("\(Int(round(w.windDirection ?? 0)))°")
                            }
                        }
                    }
                } else {
                    ContentUnavailableView("No data", systemImage: "thermometer.medium", description: Text("Pull to refresh or check connection."))
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.load()
                } label: { Image(systemName: "arrow.clockwise") }
            }
        }
        .onAppear { vm.load() }
        .overlay { if vm.isLoading { ProgressView().scaleEffect(1.2) } }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK", role: .cancel) { vm.errorMessage = nil }
        } message: { Text(vm.errorMessage ?? "") }
    }
}
