import Foundation
import Combine

struct FavoriteLocation: Identifiable, Codable, Equatable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double

    static func == (lhs: FavoriteLocation, rhs: FavoriteLocation) -> Bool {
        return lhs.name == rhs.name
    }
}

class FavoritesManager: ObservableObject {
    @Published var favoriteLocations: [FavoriteLocation] = []

    init() {
        loadFavorites()
    }

    func addFavorite(location: FavoriteLocation) {
        // Verifica si la ubicación ya existe en la lista de favoritos
        if !favoriteLocations.contains(location) {
            favoriteLocations.append(location)
            saveFavorites()
        }
    }

    func removeFavorite(at index: Int) {
        favoriteLocations.remove(at: index)
        saveFavorites()
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favoriteLocations"),
           let locations = try? JSONDecoder().decode([FavoriteLocation].self, from: data) {
            favoriteLocations = locations
        }
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteLocations) {
            UserDefaults.standard.set(data, forKey: "favoriteLocations")
        }
    }
}
