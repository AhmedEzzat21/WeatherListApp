//
//  WeatherDetailsViewModel.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

@MainActor
final class WeatherDetailsViewModel: ObservableObject {
    @Published private(set) var weather: Weather?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let city: City
    private let fetch: FetchWeather
    private let repo: WeatherRepository

    init(city: City, fetch: FetchWeather, repo: WeatherRepository) {
        self.city = city
        self.fetch = fetch
        self.repo = repo
    }

    func load() {
        isLoading = true
        Task {
            if let cached = try? repo.cachedWeather(for: city) {
                await MainActor.run { self.weather = cached }
            }
            defer { Task { @MainActor in self.isLoading = false } }
            do {
                let fresh = try await fetch(city)
                await MainActor.run { self.weather = fresh }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
