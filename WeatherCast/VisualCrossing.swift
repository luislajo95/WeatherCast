import SwiftUI

struct VisualCrossing: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var sitio: String = ""
    @State private var nombre: String = ""
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        
            VStack {
                Form {
                    HStack {
                        TextField("Ingrese el lugar...", text: $sitio)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button(action: {
                            viewModel.fetchWeather(location: sitio)
                            nombre = sitio
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.cyan)
                                .cornerRadius(8)
                        }
                        .padding()
                    }

                    VStack {
                        if let weather = viewModel.weather, let current = viewModel.currentConditions {
                            HStack{
                                Text(nombre)
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .foregroundStyle(.white)
                                    .background(.black.opacity(0.3))
                                    .swipeActions {
                                        Button {
                                            if let weather = viewModel.weather {
                                                let newFavorite = FavoriteLocation(id: favoritesManager.favoriteLocations.count + 1, name: nombre, latitude: weather.tempmax, longitude: weather.tempmin) // Ejemplo: usa tempmax y tempmin como latitud y longitud
                                                favoritesManager.addFavorite(location: newFavorite)
                                            }
                                        } label: {
                                            Label("Favorito", systemImage: "star.fill")
                                        }
                                        .tint(.yellow)
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            if let index = favoritesManager.favoriteLocations.firstIndex(where: { $0.name == nombre }) {
                                                favoritesManager.removeFavorite(at: index)
                                            }
                                        } label: {
                                            Label("Borrar", systemImage: "trash.fill")
                                        }
                                        .tint(.red)
                                    }
                            }
                            HStack{
                                
                                Text("\(weather.datetime)")
                                    .padding()
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment:.center)
                                
                            }
                            HStack{
                                
                                Text("Max Temp: \(String(format: "%.0f", weather.tempmax))°C                     Min Temp: \(String(format: "%.0f", weather.tempmin))°C                     Temp: \(String(format: "%.0f", weather.temp))°C")
                                    .padding()
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment:.leading)
                                
                                Text("Precip: \(String(format: "%.0f", weather.precip))%            Humidity: \(String(format: "%.0f", weather.humidity))%              Wind: \(String(format: "%.0f", weather.windspeed))Km/h")
                                    .padding()
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment:.leading)
                            
                            }
                            HStack{
                                
                                Text("Cond: \(current.icon)")
                                    .padding()
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment:.leading)
                                Text("")
                                
                            }
                            HStack{
                               
                   
                                
                                GIFView(name:"\(current.icon)-gif")
                                    .frame(width: 300, height: 300)
                                
                              
                            }
                                
                        } else {
                            Text("Loading weather data...")
                        }
                    }
            
                    .padding()
                }
            }
            .font(.system(size: 14))
            .padding()
        }
    }



struct VisualCrossing_Previews: PreviewProvider {
    static var previews: some View {
        VisualCrossing()
            .environmentObject(FavoritesManager())
    }
}


// Estructura que representa la respuesta JSON de la API
struct WeatherResponse: Codable {
    let resolvedAddress: String
    let days: [Day] // La respuesta contiene una lista de días
    let currentConditions: CurrentCondition
}

// Estructura que representa los datos del clima para un día
struct Day: Codable {
    let tempmax: Double // Temperatura máxima
    let tempmin: Double // Temperatura mínima
    let temp: Double
    let windspeed: Double
    let datetime: String
    let precip: Double
    let humidity: Double
    // Proporciona una propiedad para obtener una instancia de Weather desde Day
    var conditions: Weather {
        return Weather(tempmax: tempmax, tempmin: tempmin, temp: temp ,windspeed:windspeed , datetime: datetime,precip: precip, humidity: humidity)
    }
}

// Estructura que representa las condiciones actuales del clima
struct CurrentCondition: Codable {
    let temp: Double // Temperatura actual
    let conditions: String // Condiciones actuales
    let icon: String
}

// Estructura que representa los datos del clima
struct Weather: Codable {
    let tempmax: Double // Temperatura máxima
    let tempmin: Double // Temperatura mínima
    let temp: Double
    let windspeed: Double
    let datetime: String
    let precip: Double
    let humidity: Double
}


class WeatherViewModel: ObservableObject {
    @Published var weather: Weather? // Variable publicada que contiene los datos del clima
    @Published var currentConditions: CurrentCondition? // Variable publicada que contiene las condiciones actuales
    
    private let apiKey = "FUZYE9CA4BW97WK9FZ9VUYZ8S" // Clave de la API (debes reemplazarla con la tuya)
    
    // Función para obtener los datos del clima desde la API
    func fetchWeather(location: String) {
        // Construye la URL para la solicitud a la API
        let urlString = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/\(location)?unitGroup=metric&key=\(apiKey)&contentType=json"
        
        // Verifica que la URL sea válida
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // Realiza la solicitud HTTP a la API
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    // Decodifica la respuesta JSON en la estructura WeatherResponse
                    let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        // Actualiza las variables weather y currentConditions con los datos del primer día y las condiciones actuales
                        self.weather = decodedResponse.days.first?.conditions
                        self.currentConditions = decodedResponse.currentConditions
                    }
                } catch {
                    print("Failed to decode JSON: \(error)") // Imprime un error si la decodificación falla
                }
            } else if let error = error {
                print("Error fetching weather data: \(error)") // Imprime un error si la solicitud falla
            }
        }.resume() // Inicia la tarea de red
    }
}
