//
//  SavedCitiesStore.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

protocol SavedCitiesStore {
    func load() throws -> [City]
    func save(_ cities: [City]) throws
}

final class JSONSavedCitiesStore: SavedCitiesStore {
    private let fileURL: URL

    init(baseURL: URL) {
        self.fileURL = baseURL.appendingPathComponent("saved_cities.json")
    }

    func load() throws -> [City] {
        let fm = FileManager.default
        guard fm.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([City].self, from: data)
    }

    func save(_ cities: [City]) throws {
        let data = try JSONEncoder().encode(cities)
        try data.write(to: fileURL, options: [.atomic])
    }
}
