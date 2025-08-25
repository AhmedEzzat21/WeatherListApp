//
//  WeatherRow.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import SwiftUI

struct WeatherRow: View {
    let city: City
    let weather: Weather?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(city.name), \(city.country)")
                    .font(.headline)
                if let w = weather {
                    Text("\(Int(round(w.temperatureC)))°C • \(w.condition)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("—")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
           
        }
        .padding(.vertical, 8)
    }
}
