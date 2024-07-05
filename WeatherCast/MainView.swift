import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: VisualCrossing()) {
                        Text("Buscador")
                            .padding()
                            .font(.title)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: FavoritesView()) {
                        Text("Favoritos")
                            .padding()
                            .font(.title)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                }

                if let firstLocation = favoritesManager.favoriteLocations.first {
                    VStack {
                        if let weather = viewModel.weather, let current = viewModel.currentConditions {
                            HStack {
                                Text(firstLocation.name)
                                    .padding()
                                    .font(.largeTitle)
                                    .background(.blue)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Text("\(weather.datetime)")
                                    .padding()
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            HStack {
                                Text("Max Temp: \(String(format: "%.0f", weather.tempmax))°C\nMin Temp: \(String(format: "%.0f", weather.tempmin))°C\nTemp: \(String(format: "%.0f", weather.temp))°C")
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Text("Precip: \(String(format: "%.0f", weather.precip))%\nHumidity: \(String(format: "%.0f", weather.humidity))%\nWind: \(String(format: "%.0f", weather.windspeed)) Km/h")
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            HStack {
                                Text("Condition: \(current.icon)")
                                    .padding(.top)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            HStack {
                                GIFView(name: "\(current.icon)-gif")
                                    .frame(width: 300, height: 300)
                            }
                        } else {
                            Text("Cargando...")
                                .onAppear {
                                    viewModel.fetchWeather(location: firstLocation.name)
                                }
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Weather Cast")
        }
    }
}

struct MainViewView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(FavoritesManager())
    }
}
