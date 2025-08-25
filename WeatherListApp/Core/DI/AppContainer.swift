//
//  AppContainer.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation
import Combine
import Network

final class AppContainer: ObservableObject {
    // Networking clients
    let geoClient: GeocodingClient
    let weatherClient: WeatherClient
    
    // Persistence
    let savedCitiesStore: SavedCitiesStore
    let weatherCache: WeatherCache
    
    // Repositories
    let cityRepo: CityRepository
    let weatherRepo: WeatherRepository
    
    // Use cases
    let searchCities: SearchCities
    let saveCity: SaveCity
    let getSavedCities: GetSavedCities
    let removeSavedCity: RemoveSavedCity
    let fetchWeather: FetchWeather
    let refreshAllWeather: RefreshAllWeather
    
    // Network monitor
    let connectivity: Connectivity
    
    // 🔑 Shared state for instant updates
    @Published var savedCities: [City] = []
    
    init() {
        let fileManager = FileManager.default
        let persistenceURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        self.geoClient = OpenMeteoGeocodingClient()
        self.weatherClient = OpenMeteoWeatherClient()
        
        self.savedCitiesStore = JSONSavedCitiesStore(baseURL: persistenceURL)
        self.weatherCache = JSONWeatherCache(baseURL: persistenceURL)
        
        self.cityRepo = CityRepositoryImpl(geoClient: geoClient, saved: savedCitiesStore)
        self.weatherRepo = WeatherRepositoryImpl(client: weatherClient, cache: weatherCache)
        
        self.searchCities = SearchCities(cityRepo: cityRepo)
        self.saveCity = SaveCity(cityRepo: cityRepo)
        self.getSavedCities = GetSavedCities(cityRepo: cityRepo)
        self.removeSavedCity = RemoveSavedCity(cityRepo: cityRepo)
        self.fetchWeather = FetchWeather(weatherRepo: weatherRepo)
        self.refreshAllWeather = RefreshAllWeather(cityRepo: cityRepo, weatherRepo: weatherRepo)
        
        self.connectivity = Connectivity()
        
        // Load saved cities at startup
        self.savedCities = (try? savedCitiesStore.load()) ?? []
    }
    
    // 🔹 Save city and update published state
    func addCity(_ city: City) {
        do {
            try saveCity(city)
            self.savedCities = (try? savedCitiesStore.load()) ?? []
        } catch {
            print("Error saving city: \(error)")
        }
    }
    
    // 🔹 Remove city and update published state
    func removeCity(id: String) {
        do {
            try removeSavedCity(id)
            self.savedCities = (try? savedCitiesStore.load()) ?? []
        } catch {
            print("Error removing city: \(error)")
        }
    }
}
