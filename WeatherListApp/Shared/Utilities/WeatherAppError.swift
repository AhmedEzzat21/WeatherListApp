//
//  WeatherAppError.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation

enum WeatherAppError: LocalizedError {
    case network
    case decoding
    case notFound
    case offline
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .network: return "Network error. Please check your internet connection."
        case .decoding: return "Received unexpected data from server."
        case .notFound: return "City not found."
        case .offline: return "You are offline. Showing cached data."
        case .unknown(let err): return err.localizedDescription
        }
    }
}
