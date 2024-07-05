import SwiftUI

struct MainView: View {
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
                Spacer() // Este espaciador empuja el HStack hacia arriba
            }
            .padding()
            .navigationTitle("Ventana Principal")
        }
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
