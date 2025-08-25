//
//  GetSavedCities.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

struct GetSavedCities {
    private let cityRepo: CityRepository
    init(cityRepo: CityRepository) { self.cityRepo = cityRepo }
    func callAsFunction() throws -> [City] {
        try cityRepo.getSavedCities()
    }
}
