//
//  ViewController.swift
//  SimpleWeatherApp
//
//  Created by Kaleb Jubar on 2024-07-09.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var curWeatherLabel: UILabel!
    @IBOutlet weak var curWeatherImageView: UIImageView!
    @IBOutlet weak var curTempStackView: UIStackView!
    @IBOutlet weak var curTempLabel: UILabel!
    @IBOutlet weak var curCityLabel: UILabel!
    
    @IBOutlet weak var tempCButton: UIButton!
    @IBOutlet weak var tempFButton: UIButton!
    
    var locationMgr: CLLocationManager?
    var hasLocationAuth: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add items to the navbar for the home screen (location, search)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location.square.fill"), style: .plain, target: self, action: #selector(locationBtnPressed))
        
        // set up location manager
        locationMgr = CLLocationManager()
        locationMgr?.delegate = self
    }

    @IBAction func tempCBtnPressed() {
        
    }
    
    @IBAction func tempFBtnPressed() {
        
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
        curCityLabel.isHidden = !show
    }
    
    /// Update the data in the weather info displays.
    func setWeatherInfo(weatherCode: Int, temp: Double, city: String) {
        // get the display info for the weather code
        let (name, icon) = lookupWeatherCode(weatherCode)
        
        // update the display
        curWeatherLabel.text = name
        curWeatherImageView.image = icon
        curTempLabel.text = String(temp)
        curCityLabel.text = city
    }
    
    /// Given a weather code from the API, return a tuple with the display-friendly name and an icon.
    func lookupWeatherCode(_ code: Int) -> (name: String, icon: UIImage?) {
        // TODO: implement
        
        return (name: "Sunny", icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal))
    }
}

extension ViewController: CLLocationManagerDelegate {
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get the most recent location or return
        guard let location = locations.last else {
            return
        }
        
        // use a Geocoder to be able to get city
        // this is asynchronous and has a callback for when the operation is complete
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] result, err in
            // bind a strong self reference in this closure, since it's an async callback
            // like how we did with Firebase auth
            guard let strongSelf = self else {
                return
            }
            
            // show weather info
            strongSelf.setShowWeatherInfo(true)
            strongSelf.setWeatherInfo(weatherCode: 1, temp: 18.0, city: result?.first?.locality ?? "")
        }
    }
}
