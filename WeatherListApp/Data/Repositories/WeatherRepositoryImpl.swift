//
//  WeatherRepositoryImpl.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

final class WeatherRepositoryImpl: WeatherRepository {
    private let client: WeatherClient
    private let cache: WeatherCache

    init(client: WeatherClient, cache: WeatherCache) {
        self.client = client
        self.cache = cache
    }

    func fetchWeather(for city: City) async throws -> Weather {
        let w = try await client.current(latitude: city.latitude, longitude: city.longitude)
        try saveCache(for: city, weather: w)
        return w
    }

    func cachedWeather(for city: City) throws -> Weather? {
        try cache.cached(for: city.id)?.weather
    }

    func saveCache(for city: City, weather: Weather) throws {
        let snap = WeatherSnapshot(cityID: city.id, weather: weather, fetchedAt: Date())
        try cache.save(snap)
    }
}
