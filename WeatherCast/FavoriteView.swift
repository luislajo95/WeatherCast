import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(favoritesManager.favoriteLocations) { location in
                    NavigationLink(destination: WeatherDetailView(location: location)) {
                        Text(location.name)
                    }
                }
                .onDelete(perform: removeFavorite)
            }
            .navigationTitle("Favorite Locations")
        }
    }

    private func removeFavorite(at offsets: IndexSet) {
        offsets.forEach { index in
            favoritesManager.removeFavorite(at: index)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(FavoritesManager())
    }
}

