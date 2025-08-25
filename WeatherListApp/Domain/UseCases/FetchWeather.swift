//
//  FetchWeather.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

struct FetchWeather {
    private let weatherRepo: WeatherRepository
    init(weatherRepo: WeatherRepository) { self.weatherRepo = weatherRepo }
    func callAsFunction(_ city: City) async throws -> Weather {
        try await weatherRepo.fetchWeather(for: city)
    }
}

struct RefreshAllWeather {
    let cityRepo: CityRepository
    let weatherRepo: WeatherRepository
    func callAsFunction() async {
        let cities = (try? cityRepo.getSavedCities()) ?? []
        await withTaskGroup(of: Void.self) { group in
            for c in cities {
                group.addTask {
                    if let w = try? await weatherRepo.fetchWeather(for: c) {
                        try? weatherRepo.saveCache(for: c, weather: w)
                    }
                }
            }
        }
    }
}
