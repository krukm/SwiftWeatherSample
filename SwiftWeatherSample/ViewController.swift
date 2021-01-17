import UIKit

class ViewController: UIViewController {
    let networkManager = SwiftWeatherNetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getWeatherJSON() { json in
            print("did it")
        }
    }


}

