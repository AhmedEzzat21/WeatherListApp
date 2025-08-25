//
//  WeatherCache.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

protocol WeatherCache {
    func cached(for cityID: String) throws -> WeatherSnapshot?
    func save(_ snapshot: WeatherSnapshot) throws
}

final class JSONWeatherCache: WeatherCache {
    private let dirURL: URL
    init(baseURL: URL) {
        self.dirURL = baseURL.appendingPathComponent("weather_cache", isDirectory: true)
        try? FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
    }
    private func file(for id: String) -> URL { dirURL.appendingPathComponent("\(id).json") }

    func cached(for cityID: String) throws -> WeatherSnapshot? {
        let path = file(for: cityID)
        guard FileManager.default.fileExists(atPath: path.path) else { return nil }
        let data = try Data(contentsOf: path)
        return try JSONDecoder().decode(WeatherSnapshot.self, from: data)
    }

    func save(_ snapshot: WeatherSnapshot) throws {
        let data = try JSONEncoder().encode(snapshot)
        try data.write(to: file(for: snapshot.cityID), options: [.atomic])
    }
}
