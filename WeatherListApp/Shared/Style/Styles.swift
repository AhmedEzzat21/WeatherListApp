//
//  OfflineBanner.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import SwiftUI

struct OfflineBanner: View {
    let text: String
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
            Text(text)
                .font(.footnote).bold()
            Spacer()
        }
        .padding(8)
        .background(Color.yellow.opacity(0.25))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 4)
    }
}
