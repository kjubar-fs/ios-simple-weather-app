//
//  ViewController.swift
//  SimpleWeatherApp
//
//  Created by Kaleb Jubar on 2024-07-09.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

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
    var weatherTemp: Double?
    var locationStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add items to the navbar for the home screen (location, search)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location.square.fill"), style: .plain, target: self, action: #selector(locationBtnPressed))
        
        // set up location manager
        locationMgr = CLLocationManager()
        locationMgr?.delegate = self
    }

    /// Triggered when the C unit button is pressed, switches display to Celsius.
    @IBAction func tempCBtnPressed() {
        setTempUnit(inCelsius: true)
    }
    
    /// Triggered when the F unit button is pressed, switches display to Fahrenheit.
    @IBAction func tempFBtnPressed() {
        setTempUnit(inCelsius: false)
    }
    
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
    
    /// Show or hide the weather info displays.
    func setShowWeatherInfo(_ show: Bool) {
        curWeatherLabel.isHidden = !show
        curWeatherImageView.isHidden = !show
        curTempStackView.isHidden = !show
        curLocLabel.isHidden = !show
    }
    
    /// Set the data in the class and refresh weather info displays.
    func setWeatherInfo(weatherCode: Int, temp: Double, location: String) {
        // get the display info for the weather code
        let (name, icon) = lookupWeatherCode(weatherCode)
        
        // store in variables
        weatherDispName = name
        weatherIcon = icon
        weatherTemp = temp
        locationStr = location
        
        // update display
        updateWeatherDisplay()
    }
    
    /// Update the display views for the weather info with the info in the class.
    func updateWeatherDisplay() {
        // update the display
        curWeatherLabel.text = weatherDispName
        curWeatherImageView.image = weatherIcon
        curTempLabel.text = String(weatherTemp ?? 0)
        curLocLabel.text = locationStr
    }
    
    /// Given a weather code from the API, return a tuple with the display-friendly name and an icon.
    func lookupWeatherCode(_ code: Int) -> (name: String, icon: UIImage?) {
        // TODO: implement
        
        return (name: "Sunny", icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal))
    }
    
    /// Set the temperature unit.
    /// If inCelsius is true, set to Celsius. Otherwise, set to Fahrenheit.
    func setTempUnit(inCelsius: Bool) {
        if (inCelsius) {
            
        } else {
            
        }
    }
}

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
        
        // use a Geocoder to be able to get city
        // this is asynchronous and has a callback for when the operation is complete
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] results, err in
            // bind a strong self reference in this closure, since it's an async callback
            // like how we did with Firebase auth
            guard let strongSelf = self, let resultLoc = results?.first else {
                return
            }
            
            // show weather info
            strongSelf.setShowWeatherInfo(true)
            strongSelf.setWeatherInfo(weatherCode: 1, temp: 18.0, location: "\(resultLoc.locality ?? ""), \(resultLoc.administrativeArea ?? ""), \(resultLoc.country ?? "")")
        }
    }
}
