//
//  WeatherCodeMapper.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

enum WeatherCodeMapper {
    static func text(for code: Int) -> String {
        switch code {
        case 0: return "Clear"
        case 1,2,3: return "Partly cloudy"
        case 45,48: return "Fog"
        case 51,53,55: return "Drizzle"
        case 61,63,65: return "Rain"
        case 66,67: return "Freezing rain"
        case 71,73,75: return "Snow"
        case 77: return "Snow grains"
        case 80,81,82: return "Rain showers"
        case 85,86: return "Snow showers"
        case 95: return "Thunderstorm"
        case 96,99: return "Thunderstorm w/ hail"
        default: return "Unknown"
        }
    }
}
