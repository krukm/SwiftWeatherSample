import UIKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    let networkManager = SwiftWeatherNetworkManager()
    let locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var currentConditions: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var citySearch: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citySearch.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = citySearch.text?.replacingOccurrences(of: " ", with: "%20") else { return }
        
        networkManager.getWeatherJSON(city: city) { weather in
            DispatchQueue.main.async {
                self.setupView(currentWeather: weather)
                self.citySearch.text = ""
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        networkManager.getWeatherJSON(lat: String(location.latitude), lon: String(location.longitude)) { weather in
            DispatchQueue.main.async {
                self.setupView(currentWeather: weather)
            }
        }
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
