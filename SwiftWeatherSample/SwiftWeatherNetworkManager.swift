import Foundation

class SwiftWeatherNetworkManager {
    let apiKey = Constants.openWeatherApiKey

    func getWeatherJSON(completion: @escaping (WeatherObject) -> ()) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=ann%20arbor&appid=\(apiKey)&units=imperial"
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let weather = try decoder.decode(WeatherObject.self, from: data)
                        completion(weather)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
