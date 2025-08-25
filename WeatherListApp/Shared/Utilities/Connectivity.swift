//
//  Connectivity.swift
//  WeatherListApp
//
//  Created by Ahmed Ezzat on 25/08/2025.
//

import Foundation
import Network
import Combine

final class Connectivity: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Connectivity")

    @Published private(set) var isOnline: Bool = true

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOnline = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
}
