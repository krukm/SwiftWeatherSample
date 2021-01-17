struct WeatherObject: Codable {
    var coord: Coord
    var weather: [Weather]
    var base: String
    var main: Main
    var visibility: Int
    var wind: Wind
    var snow: Snow?
    var rain: Rain?
    var clouds: Clouds
    var dt: Int
    var sys: Sys
    var timezone: Int
    var id: Int
    var name: String
    var cod: Int
    
    struct Coord: Codable {
        var lon: Double
        var lat: Double
    }
    
    struct Weather: Codable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }
    
    struct Main: Codable {
        var temp: Double
        var feelsLike: Double
        var tempMin: Double
        var tempMax: Double
        var pressure: Int
        var humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case humidity
        }
    }
    
    struct Wind: Codable {
        var speed: Double
        var deg: Int
    }
    
    struct Snow: Codable {
        var oneHour: Double?
        var threeHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }
    
    struct Rain: Codable {
        var oneHour: Double?
        var threeHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }
    
    struct Clouds: Codable {
        var all: Int
    }
    
    struct Sys: Codable {
        var type: Int
        var id: Int
        var country: String
        var sunrise: Int
        var sunset: Int
    }
}
