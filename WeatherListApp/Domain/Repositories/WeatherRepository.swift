//
//  WeatherRepository.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

protocol WeatherRepository {
    func fetchWeather(for city: City) async throws -> Weather
    func cachedWeather(for city: City) throws -> Weather?
    func saveCache(for city: City, weather: Weather) throws
}
