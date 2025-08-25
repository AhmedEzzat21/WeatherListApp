//
//  SavedCitiesViewModel.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation
import Combine


@MainActor
final class SavedCitiesViewModel: ObservableObject {
    @Published private(set) var items: [(City, Weather?)] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    
    private let fetchWeather: FetchWeather
    private let weatherRepo: WeatherRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(fetchWeather: FetchWeather, weatherRepo: WeatherRepository) {
        self.fetchWeather = fetchWeather
        self.weatherRepo = weatherRepo
    }
    
    func bind(to container: AppContainer) {
        container.$savedCities
            .sink { [weak self] cities in
                Task { await self?.reload(cities) }
            }
            .store(in: &cancellables)
    }
    
    private func reload(_ cities: [City]) async {
        var pairs: [(City, Weather?)] = []
        for c in cities {
            let cached = (try? weatherRepo.cachedWeather(for: c)) ?? nil
            pairs.append((c, cached))
        }
        await MainActor.run {
            self.items = pairs
        }
    }
    
    func refresh(container: AppContainer) async {
        let cities = container.savedCities
        isLoading = true
        defer { isLoading = false }
        
        await withTaskGroup(of: (City, Weather?).self) { group in
            for c in cities {
                group.addTask {
                    do {
                        let w = try await self.fetchWeather(c)
                        return (c, w)
                    } catch let appError as WeatherAppError {
                        await MainActor.run {
                            self.errorMessage = appError.errorDescription
                        }
                        let cached = try? self.weatherRepo.cachedWeather(for: c)
                        return (c, cached)
                    } catch {
                        await MainActor.run {
                            self.errorMessage = error.localizedDescription
                        }
                        let cached = try? self.weatherRepo.cachedWeather(for: c)
                        return (c, cached)
                    }
                }
            }
            var arr: [(City, Weather?)] = []
            for await pair in group { arr.append(pair) }
            await MainActor.run {
                self.items = arr.sorted { $0.0.name < $1.0.name }
            }
        }
    }
}
