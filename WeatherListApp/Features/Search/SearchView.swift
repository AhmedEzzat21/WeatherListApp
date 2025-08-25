//
//  SearchView.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var container: AppContainer
    @StateObject private var vm = SearchViewModel()
    @Binding var tabSelection: TabSelection   // 🔑 binding from RootView

    var body: some View {
        VStack(spacing: 0) {
            if !container.connectivity.isOnline {
                OfflineBanner(text: "You are offline • showing cached data only")
            }
            List {
                Section {
                    ForEach(vm.results, id: \.id) { city in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(city.name).font(.headline)
                                Text(city.country).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button {
                                handleSelect(city)
                            } label: {
                                Image(systemName: "plus.circle.fill").imageScale(.large)
                            }
                            .buttonStyle(.plain)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            handleSelect(city)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Search")
        .searchable(text: $vm.query,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "City name")
        .overlay { if vm.isLoading { ProgressView().scaleEffect(1.2) } }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK", role: .cancel) { vm.errorMessage = nil }
        } message: { Text(vm.errorMessage ?? "") }
        .onAppear {
            vm.inject(searchCities: container.searchCities,
                      saveCity: container.saveCity)
        }
    }

    private func handleSelect(_ city: City) {
        container.addCity(city)   // save
        vm.clearSearch()          // clear query & results
        tabSelection = .saved     // 🔑 navigate to Favorites tab
    }
}
