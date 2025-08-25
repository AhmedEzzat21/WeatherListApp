//
//  Weather.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

public struct Weather: Codable, Equatable {
    public let temperatureC: Double
    public let windSpeed: Double?
    public let windDirection: Double?
    public let condition: String
    public let time: Date

    public init(temperatureC: Double, windSpeed: Double?, windDirection: Double?, condition: String, time: Date) {
        self.temperatureC = temperatureC
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.condition = condition
        self.time = time
    }
}

public struct WeatherSnapshot: Codable {
    public let cityID: String
    public let weather: Weather
    public let fetchedAt: Date
}
