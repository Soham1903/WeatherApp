import Foundation

class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var weather: WeatherData? = nil
    @Published var isLoading = false
    
    func fetchWeather(){
        guard !city.isEmpty else { return }
        isLoading = true
        WeatherAPI.shared.getWeather(for: city){ result in
            DispatchQueue.main.async{
                self.isLoading = false
                switch result {
                case .success(let weatherData):
                    self.weather = weatherData
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.weather = nil
                }
            }
            
        }
    }
}
