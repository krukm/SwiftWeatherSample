import Foundation

class SwiftWeatherNetworkManager {
    let apiKey = Constants.openWeatherApiKey
    var weatherArray = [WeatherObject]()

    func getWeatherJSON(completion: @escaping (WeatherObject) -> ()) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=ann%20arbor&appid=\(apiKey)"
        if let url = URL(string: urlString) {
            print(url)
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    print(String(data: data, encoding: .utf8)!)
                    
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
