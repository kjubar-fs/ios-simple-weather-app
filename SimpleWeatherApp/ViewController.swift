//
//  ViewController.swift
//  SimpleWeatherApp
//
//  Created by Kaleb Jubar on 2024-07-09.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    // MARK: - outlets and class variables

    // weather display Views
    @IBOutlet weak var curWeatherLabel: UILabel!
    @IBOutlet weak var curWeatherImageView: UIImageView!
    @IBOutlet weak var curTempStackView: UIStackView!
    @IBOutlet weak var curTempLabel: UILabel!
    @IBOutlet weak var curLocLabel: UILabel!
    
    // temperature unit buttons
    @IBOutlet weak var tempCButton: UIButton!
    @IBOutlet weak var tempFButton: UIButton!
    
    // location services-related vars
    var locationMgr: CLLocationManager?
    var hasLocationAuth: Bool = false
    
    // current weather/location info
    var weatherDispName: String?
    var weatherIcon: UIImage?
    var displayTempInC: Bool = true
    var weatherTempC: Double?
    var weatherTempF: Double?
    var locationStr: String?
    
    // configurations used for changing unit button styles
    let unitBtnTextTransformer = UIConfigurationTextAttributesTransformer { incoming in
        var outgoing = incoming
        outgoing.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        return outgoing
    }
    var btnSelectedStyle: UIButton.Configuration = .filled()
    var btnDeselectedStyle: UIButton.Configuration = .gray()
    
    // MARK: - VC load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add items to the navbar for the home screen (location, search)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location.square.fill"), style: .plain, target: self, action: #selector(locationBtnPressed))
        
        // set up location manager
        locationMgr = CLLocationManager()
        locationMgr?.delegate = self
        
        // set up style configs for unit toggle buttons
        // this has to be done in a more complex way in code because there is not
        // an easy way to switch the "Style" property of the buttons, like we can
        // in the storyboard config
        btnSelectedStyle.titleTextAttributesTransformer = unitBtnTextTransformer
        btnDeselectedStyle.titleTextAttributesTransformer = unitBtnTextTransformer
        
        var initCBtnStyle = btnSelectedStyle
        initCBtnStyle.title = "C"
        var initFBtnStyle = btnDeselectedStyle
        initFBtnStyle.title = "F"
        
        tempCButton.configuration = initCBtnStyle
        tempFButton.configuration = initFBtnStyle
    }
    
    // MARK: - location functions
    
    /// Function for when location button is pressed.
    /// Requests location permissions (if necessary) and gets/displays the weather at the user's location.
    @objc func locationBtnPressed() {
        // request authorization for location (does nothing if we have it already)
        locationMgr?.requestAlwaysAuthorization()
        
        // start location updates
        startUpdatingLocation()
    }
    
    /// Start updating the user's location.
    /// This will fetch and display the weather for the user's location.
    func startUpdatingLocation() {
        // do nothing if we can't use location
        if (!hasLocationAuth) {
            return
        }
        
        locationMgr?.startUpdatingLocation()
    }
    
    /// Stop updating the user's location.
    /// Call this when switching to a static location instead of the user's location.
    func stopUpdatingLocation() {
        locationMgr?.stopUpdatingLocation()
    }
    
    // MARK: - weather UI functions
    
    /// Show or hide the weather info displays.
    func setShowWeatherInfo(_ show: Bool) {
        curWeatherLabel.isHidden = !show
        curWeatherImageView.isHidden = !show
        curTempStackView.isHidden = !show
        curLocLabel.isHidden = !show
    }
    
    /// Set the data in the class and refresh weather info displays.
    func setWeatherInfo(weatherCode: Int, weatherString: String, tempC: Double, tempF: Double, location: String) {
        // store in variables
        weatherDispName = weatherString
        weatherIcon = lookupWeatherCode(weatherCode)
        weatherTempC = tempC
        weatherTempF = tempF
        locationStr = location
        
        // update display
        updateWeatherDisplay()
    }
    
    /// Given a weather code from the API, return a tuple with the display-friendly name and an icon.
    func lookupWeatherCode(_ code: Int) -> UIImage? {
        // TODO: implement
        
        return UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal)
    }
    
    /// Update the display views for the weather info with the info in the class.
    func updateWeatherDisplay() {
        // update the display
        curWeatherLabel.text = weatherDispName
        curWeatherImageView.image = weatherIcon
        curTempLabel.text = displayTempInC ? String(weatherTempC ?? 0) : String(weatherTempF ?? 0)
        curLocLabel.text = locationStr
    }
    
    // MARK: - temperature unit functions
    
    /// Triggered when the C unit button is pressed, switches display to Celsius.
    @IBAction func tempCBtnPressed() {
        setTempUnit(inCelsius: true)
    }
    
    /// Triggered when the F unit button is pressed, switches display to Fahrenheit.
    @IBAction func tempFBtnPressed() {
        setTempUnit(inCelsius: false)
    }
    
    /// Set the temperature unit.
    /// If inCelsius is true, set to Celsius. Otherwise, set to Fahrenheit.
    func setTempUnit(inCelsius: Bool) {
        // if we're already displaying in the requested mode, do nothing
        if (displayTempInC == inCelsius) {
            return
        }
        
        // create style config for both buttons
        var newCBtnStyle: UIButton.Configuration
        var newFBtnStyle: UIButton.Configuration
        if (inCelsius) {
            // set Celsius selected
            newCBtnStyle = btnSelectedStyle
            newFBtnStyle = btnDeselectedStyle
        } else {
            // set Fahrenheit selected
            newCBtnStyle = btnDeselectedStyle
            newFBtnStyle = btnSelectedStyle
        }
        newCBtnStyle.title = "C"
        newFBtnStyle.title = "F"
        
        // apply styles to buttons
        tempCButton.configuration = newCBtnStyle
        tempFButton.configuration = newFBtnStyle
        
        // update display mode flag and refresh UI
        displayTempInC = inCelsius
        updateWeatherDisplay()
    }
}

// MARK: - LocationManager delegate functions

extension ViewController: CLLocationManagerDelegate {
    /// Delegate function for location authorization changes.
    /// Enables location updates when successfully authorized, disables when not authorized.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // check what auth response we got
        switch manager.authorizationStatus {
            // for in-use and always, start location updates
            case .authorizedWhenInUse: fallthrough
            case .authorizedAlways:
                hasLocationAuth = true
                startUpdatingLocation()
            
            // for all other cases, stop location updates
            case .notDetermined: fallthrough
            case .restricted: fallthrough
            case .denied: fallthrough
            @unknown default:
                hasLocationAuth = false
                stopUpdatingLocation()
        }
    }
    
    /// Delegate function for location changes.
    /// Get information and weather for the new location and display it.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get the most recent location or return
        guard let location = locations.last else {
            return
        }
        
        // attempt to make the API call URL
        // if we can't make a URL for the API, return because we can't do anything
        guard let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=b8346bfb465743ed8f2172517241007&q=\(location.coordinate.latitude),\(location.coordinate.longitude)") else {
            return
        }
        
        // create the dataTask for querying the API
        // takes a callback function to be executed when the task finishes, as it is async
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            // report any errors and quit if they exist
            if let fetchErr = error {
                print("Error calling API: \(fetchErr)")
                return
            }
            
            // quit if we got no data
            guard let data = data else {
                return
            }
            
            // TODO: quit if API responds with not 200-299
            
            // create a JSON decoder for reading the response
            let jsonDecoder = JSONDecoder()
            do {
                // attempt to decode the data
                let decodedData: WeatherAPIResponse = try jsonDecoder.decode(WeatherAPIResponse.self, from: data)
                
                // pull out weather info from data
                let code = decodedData.current.condition.code
                let weatherDispName = decodedData.current.condition.text
                let tempC = decodedData.current.temp_c
                let tempF = decodedData.current.temp_f
                let city = decodedData.location.name
                let region = decodedData.location.region
                let country = decodedData.location.country
                
                // update the UI with the info
                // use the DispatchQueue to update on the main thread
                DispatchQueue.main.async {
                    self.setShowWeatherInfo(true)
                    self.setWeatherInfo(weatherCode: code, weatherString: weatherDispName, tempC: tempC, tempF: tempF, location: "\(city), \(region), \(country)")
                }
            } catch {
                // if we fail decoding, log the error
                print(error)
            }
        }
        
        // start the task to hit the API
        dataTask.resume()
    }
}

// MARK: - weather API JSON structs

/// Structs for decoding the API response data.
/// These match the structure of the JSON data returned by the API.

struct WeatherCondition: Decodable {
    let text: String
    let code: Int
}

struct CurrentWeather: Decodable {
    let temp_c: Double
    let temp_f: Double
    let condition: WeatherCondition
}

struct LocationData: Decodable {
    let name: String
    let region: String
    let country: String
}

struct WeatherAPIResponse: Decodable {
    let location: LocationData
    let current: CurrentWeather
}
