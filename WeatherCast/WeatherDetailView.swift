import SwiftUI
import FLAnimatedImage
struct WeatherDetailView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @ObservedObject var viewModel = WeatherViewModel()
    @State private var showGif = false
    let delayInSeconds: Double = 3.0 // Specify your delay here
    var location: FavoriteLocation
    
    var body: some View {

           
            VStack {
                if let weather = viewModel.weather, let current = viewModel.currentConditions {
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
                        
                        Text("Precip: \(String(format: "%.0f", weather.precip))%            Humidity: \(String(format: "%.0f", weather.humidity))%              Wind: \(String(format: "%.0f", weather.windspeed))°Km/h")
                            .padding()
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment:.leading)
                        
             
                    }
                    HStack{
                       
                        Text("Cond: \(current.icon)")
                            .padding()
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment:.leading)
                        
                        GIFView(name:"\(current.icon)-gif")
                            .frame(width: 200, height: 200)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment:.leading)
                        
                      
                    }
            
                        
                } else {
                    Text("Loading weather data...")
                }
            }
            .foregroundStyle(.black)
            .onAppear {
                viewModel.fetchWeather(location: "\(location.latitude),\(location.longitude)")
            }
            .navigationTitle(location.name)
            Spacer()
    }
}
    struct WeatherDetailView_Previews: PreviewProvider {
        static var previews: some View {
            WeatherDetailView(location: FavoriteLocation(id: 1, name: "Sample Location", latitude: 0.0, longitude: 0.0))
                .environmentObject(FavoritesManager())
        }
    }

