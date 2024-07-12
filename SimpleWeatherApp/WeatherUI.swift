//
//  WeatherUI.swift
//  SimpleWeatherApp
//
//  Created by Berk Ozdemir on 2024-07-11.
//

import UIKit

extension ViewController {
    
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
        weatherIcon = getWeatherIcon(weatherString)
        weatherTempC = tempC
        weatherTempF = tempF
        locationStr = location
        
        // update display
        updateWeatherDisplay()
    }
    
    /// Update the display views for the weather info with the info in the class.
    func updateWeatherDisplay() {
        // update the display
        curWeatherLabel.text = weatherDispName
        curWeatherImageView.image = weatherIcon
        curTempLabel.text = displayTempInC ? String(weatherTempC ?? 0) : String(weatherTempF ?? 0)
        curLocLabel.text = locationStr
    }
    
}
