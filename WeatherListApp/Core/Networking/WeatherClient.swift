//
//  WeatherClient.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

protocol WeatherClient {
    func current(latitude: Double, longitude: Double) async throws -> Weather
}

final class OpenMeteoWeatherClient: WeatherClient {
    func current(latitude: Double, longitude: Double) async throws -> Weather {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true")
        else { throw WeatherAppError.notFound }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            struct Response: Decodable {
                struct Current: Decodable {
                    let temperature: Double
                    let windspeed: Double?
                    let winddirection: Double?
                    let weathercode: Int?
                    let time: String
                }
                let current_weather: Current
            }
            let decoded = try JSONDecoder().decode(Response.self, from: data)
            let cur = decoded.current_weather
            let formatter = ISO8601DateFormatter()
            let date = formatter.date(from: cur.time) ?? Date()
            let condition = WeatherCodeMapper.text(for: cur.weathercode ?? 0)
            return Weather(
                temperatureC: cur.temperature,
                windSpeed: cur.windspeed,
                windDirection: cur.winddirection,
                condition: condition,
                time: date
            )
        } catch is URLError {
            throw WeatherAppError.network
        } catch is DecodingError {
            throw WeatherAppError.decoding
        } catch {
            throw WeatherAppError.unknown(error)
        }
    }
}
