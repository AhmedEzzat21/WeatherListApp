## 🌤 WeatherListApp

A simple, clean iOS 16+ SwiftUI application that lets users search for cities, save them to a favorites list, and view current weather conditions. Supports offline persistence, pull-to-refresh, and detailed weather info.

## ✨ Features

🔍 Search Cities

Type city name and get suggestions from Open-Meteo Geocoding API
.

Results update with debounced search using Combine.

Save cities to favorites with a single tap.

⭐ Favorites List

Shows saved cities with:

City name

Current temperature (°C)

Weather condition

Pull-to-refresh to fetch updated data.

Swipe-to-delete to remove a city.

📊 Weather Details

Tap any city for more information:

Temperature

Wind speed & direction

Condition (mapped from weather codes)

Last updated time

📡 Offline Support

Saved cities persist across app launches.

Weather data is cached locally in JSON files.

When offline, cached data is displayed with a visual banner.

⚙️ Architecture

Clean separation of layers:

Domain (entities & use cases)

Data (repositories, clients, persistence)

UI (SwiftUI views & view models)

Protocol-based dependency injection

Async/await networking

Combine for reactive search

Modular, testable design

🛠 Technical Stack

Platform: iOS 16+

Language: Swift 5.9

UI Framework: SwiftUI + NavigationStack

Concurrency: Swift Concurrency (async/await)

Reactive: Combine (search text debouncing, state updates)

Persistence: JSON file storage (saved cities + cached weather)

Networking: URLSession

Error Handling: Custom WeatherAppError with user-friendly messages

Connectivity: NWPathMonitor to detect offline state

##📂 Project Structure

WeatherListApp/
├── App/                     # App entry + RootView
├── Core/
│   ├── DI/                  # Dependency container
│   ├── Networking/          # API clients
│   └── Persistence/         # Local storage (JSON)
├── Data/Repositories/       # Repository implementations
├── Domain/
│   ├── Models/              # City, Weather
│   ├── Repositories/        # Protocols
│   └── UseCases/            # Search, Save, Fetch...
├── Features/
│   ├── Search/              # SearchView + ViewModel
│   ├── Saved/               # SavedCitiesView + ViewModel
│   └── Details/             # WeatherDetailsView + ViewModel
├── Shared/
│   ├── Components/          # Reusable SwiftUI views
│   ├── Style/               # Styles, banners
│   └── Utilities/           # Errors, connectivity, helpers
└── README.md

## 🔗 API Endpoints

City search

https://geocoding-api.open-meteo.com/v1/search?name=<query>&count=5


Current weather

https://api.open-meteo.com/v1/forecast?latitude=<lat>&longitude=<lon>&current_weather=true

## ✅ Evaluation Highlights

Clean, modular architecture with DI

Swift Concurrency (async/await) networking

Combine for debounced search

Offline persistence & caching

Error handling with user-friendly messages

Separation of concerns across layers

Simple, modern SwiftUI interface
