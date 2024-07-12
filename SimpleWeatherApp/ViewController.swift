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
    
    // search bar View
    @IBOutlet weak var locationSearchField: UITextField!
    
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
    
    // saved cities/locations
    var savedLocations: [WeatherAPIResponse] = []
    
    // MARK: - VC load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add items to the navbar for the home screen (location, search)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location.square.fill"), style: .plain, target: self, action: #selector(locationBtnPressed))
        navigationItem.titleView = locationSearchField
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(doLocationSearch))
        
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
        
        // set up the intro text for when the app is first opened
        // adapted from https://stackoverflow.com/questions/75513158/how-do-you-add-an-image-attachment-to-an-attributedstring
        let introIcon = NSTextAttachment(image: UIImage(systemName: "location.square.fill")!)
        let iconPlaceholder = "ICON"
        let introLabel = "Search for a location or tap \(iconPlaceholder) to begin."
        
        let attributedString = NSMutableAttributedString(string: introLabel)
        attributedString.replaceCharacters(in: (attributedString.string as NSString).range(of: iconPlaceholder), with: NSAttributedString(attachment: introIcon))
        curLocLabel.attributedText = attributedString
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
    
    /// Function for when search button is pressed, or the user hits Enter in the search bar.
    /// Takes the city from the search bar and looks up the weather for it, and stores the location.
    @objc func doLocationSearch() {
        print("Searching for location...")
        
        guard let location = locationSearchField.text else {
            return
        }
        
        locationSearchField.resignFirstResponder()
        locationSearchField.text = ""
        stopUpdatingLocation()
        getWeatherForLocation(location)
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
    
    /// Prepare to perform a segue.
    /// Handles passing in list of saved cities to the second screen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewCityList") {
            if let dest = segue.destination as? CityListViewController {
                dest.locationList = savedLocations
            }
        }
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
        
        getWeatherForLocation("\(location.coordinate.latitude),\(location.coordinate.longitude)")
    }
}

// MARK: - search bar delegate functions

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Returning")
        doLocationSearch()
        return true
    }
}
