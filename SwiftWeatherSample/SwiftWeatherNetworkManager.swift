import Foundation

class SwiftWeatherNetworkManager {
    let apiKey = Constants.openWeatherApiKey

    func getWeatherJSON(city: String = "", lat: String = "", lon: String = "", completion: @escaping (WeatherObject) -> ()) {
        var urlString = ""
        
        if !city.isEmpty {
            urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=imperial"
        } else if !lat.isEmpty && !lon.isEmpty {
            urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial"
        } else {
            urlString = "http://api.openweathermap.org/data/2.5/weather?q=new%20york&appid=\(apiKey)&units=imperial"
        }
        
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
