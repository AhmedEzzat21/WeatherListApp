//
//  SearchCities.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//
import Foundation

struct SearchCities {
    private let cityRepo: CityRepository
    init(cityRepo: CityRepository) { self.cityRepo = cityRepo }
    func callAsFunction(_ query: String) async throws -> [City] {
        try await cityRepo.searchCities(query: query)
    }
}
