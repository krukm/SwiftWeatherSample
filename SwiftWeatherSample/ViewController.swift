import UIKit

class ViewController: UIViewController {
    let networkManager = SwiftWeatherNetworkManager()

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var currentConditions: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getWeatherJSON() { weatherJson in
            
            DispatchQueue.main.async {
                self.setupView(currentWeather: weatherJson)
            }
        }
    }
    
    func setupView(currentWeather: WeatherObject) {
        
        let formatTime = DateFormatter()
        formatTime.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatTime.timeStyle = .short
        formatTime.dateStyle = .none
        
        let icon = extractWeatherNodeData(weatherObject: currentWeather, nodeName: "icon")
        guard let url = URL(string: "http://openweathermap.org/img/w/\(icon).png") else { return }
        weatherIcon.loadImge(withUrl: url)
        
        cityName.text = currentWeather.name
        currentTemp.text = "\(String(Int(round(currentWeather.main.temp))))°"
        weatherIcon.image = UIImage().withTintColor(.cyan)
        currentConditions.text = extractWeatherNodeData(weatherObject: currentWeather, nodeName: "description")
        feelsLike.text = "feels like \(String(Int(round(currentWeather.main.feelsLike))))°"
        humidity.text = "humidity \(String(currentWeather.main.humidity))%"
        
        sunrise.text = "sunrise \(formatTime.string(from: Date(timeIntervalSince1970: TimeInterval(currentWeather.sys.sunrise))))"
        sunset.text = "sunset \(formatTime.string(from: Date(timeIntervalSince1970: TimeInterval(currentWeather.sys.sunset))))"
    }
    
    func extractWeatherNodeData(weatherObject: WeatherObject, nodeName: String) -> String {
        var node = ""
        
        for weather in weatherObject.weather {
            switch nodeName {
            case "id":
                node = String(weather.id)
            case "main":
                node = weather.main
            case "description":
                node = weather.description
            case "icon":
                node = weather.icon
            default:
                node = ""
            }
        }
        return node
    }
}

extension UIImageView {
    func loadImge(withUrl url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
