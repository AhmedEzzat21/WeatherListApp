//
//  CityRepositoryImpl.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

final class CityRepositoryImpl: CityRepository {
    private let geoClient: GeocodingClient
    private let saved: SavedCitiesStore

    init(geoClient: GeocodingClient, saved: SavedCitiesStore) {
        self.geoClient = geoClient
        self.saved = saved
    }

    func searchCities(query: String) async throws -> [City] {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return [] }
        return try await geoClient.search(name: query, count: 5)
    }

    func getSavedCities() throws -> [City] {
        try saved.load()
    }

    func saveCity(_ city: City) throws {
        var list = try saved.load()
        guard !list.contains(where: {$0.id == city.id}) else { return }
        list.append(city)
        try saved.save(list)
    }

    func removeCity(id: String) throws {
        var list = try saved.load()
        list.removeAll { $0.id == id }
        try saved.save(list)
    }
}
