//
//  GeocodingClient.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

protocol GeocodingClient {
    func search(name: String, count: Int) async throws -> [City]
}

final class OpenMeteoGeocodingClient: GeocodingClient {
    func search(name: String, count: Int = 5) async throws -> [City] {
        guard let q = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=\(q)&count=\(count)")
        else {
            throw WeatherAppError.notFound
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            struct Response: Decodable {
                struct Entry: Decodable {
                    let id: Int?
                    let name: String
                    let country: String?
                    let latitude: Double
                    let longitude: Double
                }
                let results: [Entry]?
            }
            let decoded = try JSONDecoder().decode(Response.self, from: data)
            let items = decoded.results ?? []
            if items.isEmpty {
                throw WeatherAppError.notFound
            }
            return items.map { e in
                City(
                    id: String(e.id ?? Int.random(in: 100000...999999)),
                    name: e.name,
                    country: e.country ?? "",
                    latitude: e.latitude,
                    longitude: e.longitude
                )
            }
        } catch is URLError {
            throw WeatherAppError.network
        } catch is DecodingError {
            throw WeatherAppError.decoding
        } catch {
            throw WeatherAppError.unknown(error)
        }
    }
}
