//
//  WeatherCastApp.swift
//  WeatherCast
//
//  Created by luis lajo borderias on 13/6/24.
//

import SwiftUI

@main
struct WeatherCast: App {
    @StateObject private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(favoritesManager)
        }
    }
}
