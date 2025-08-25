//
//  CityRepository.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

protocol CityRepository {
    func searchCities(query: String) async throws -> [City]
    func getSavedCities() throws -> [City]
    func saveCity(_ city: City) throws
    func removeCity(id: String) throws
}
