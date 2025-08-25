//
//  SearchViewModel.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var results: [City] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    private var searchCities: SearchCities?
    private var saveCity: SaveCity?

    init() {
        bind()
    }

    func inject(searchCities: SearchCities, saveCity: SaveCity) {
        self.searchCities = searchCities
        self.saveCity = saveCity
    }

    private func bind() {
        $query
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] q in
                Task { await self?.performSearch(q) }
            }
            .store(in: &cancellables)
    }

    private func performSearch(_ q: String) async {
        guard let searchCities = searchCities else { return }
        if q.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            results = []
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            results = try await searchCities(q)
            errorMessage = nil
        } catch let appError as WeatherAppError {
            errorMessage = appError.errorDescription
            results = []
        } catch {
            errorMessage = error.localizedDescription
            results = []
        }
    }

    func save(_ city: City) {
        guard let saveCity = saveCity else { return }
        do { try saveCity(city) }
        catch let appError as WeatherAppError {
            errorMessage = appError.errorDescription
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }

    func clearSearch() {
        query = ""
        results = []
    }
}
