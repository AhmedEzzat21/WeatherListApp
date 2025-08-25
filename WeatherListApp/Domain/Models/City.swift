//
//  City.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

public struct City: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let country: String
    public let latitude: Double
    public let longitude: Double

    public init(id: String = UUID().uuidString, name: String, country: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
}
