//
//  SaveCity.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

struct SaveCity {
    private let cityRepo: CityRepository
    init(cityRepo: CityRepository) { self.cityRepo = cityRepo }
    func callAsFunction(_ city: City) throws {
        try cityRepo.saveCity(city)
    }
}

struct RemoveSavedCity {
    private let cityRepo: CityRepository
    init(cityRepo: CityRepository) { self.cityRepo = cityRepo }
    func callAsFunction(_ id: String) throws {
        try cityRepo.removeCity(id: id)
    }
}
