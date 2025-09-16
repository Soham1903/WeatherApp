import Foundation

struct WeatherData {
    let cityName: String
    let temperature: Double
    let description: String
}

class WeatherAPI {
    static let shared = WeatherAPI()
    private init() {}
    
    func getWeather(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let apiKey = "07d917ecdb2d454a845114156251609"
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(cityQuery)&aqi=yes"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        print(url)
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let weather = WeatherData(
                    cityName: decoded.location.name,
                    temperature: decoded.current.temp_c,
                    description: decoded.current.condition.text
                )
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
