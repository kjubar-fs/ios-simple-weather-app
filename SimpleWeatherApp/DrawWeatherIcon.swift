//
//  DrawWeatherIcon.swift
//  SimpleWeatherApp
//
//  Created by Berk Ozdemir on 2024-07-11.
//

import UIKit

extension ViewController {
    /// Given the weather display name from the API, return a UIImage representing the weather.
    func getWeatherIcon(_ weatherName: String) -> UIImage? {
        // lowercase the weather name input to check against
        let weather = weatherName.lowercased()
        
        // color palette arrays
        let yellow: [UIColor] = [.systemYellow]
        let gray: [UIColor] = [.systemGray]
        let white: [UIColor] = [.white]
        let whiteYellow: [UIColor] = [.white, .systemYellow]
        let whiteBlue: [UIColor] = [.white, .systemBlue]
        let grayLightgray: [UIColor] = [.systemGray, .lightGray]
        let grayWhite: [UIColor] = [.systemGray, .white]
        let whiteGray: [UIColor] = grayWhite.reversed()
        
        // determine icon based on weather string contents
        var iconName: String
        var palette: [UIColor]
        
        // MARK: no weather
        if (weather.contains("sunny")) {
            iconName = "sun.max.fill"
            palette = yellow
        }
        // "clear" is only used for nighttime, so we can show a moon
        else if (weather.contains("clear")) {
            iconName = "moon.fill"
            palette = white
        }
        
        // MARK: cloudy
        // "partly cloudy" should take precedence over "cloudy"
        else if (weather.contains("partly cloudy")) {
            iconName = "cloud.sun.fill"
            palette = whiteYellow
        }
        else if (weather.contains("cloudy")) {
            iconName = "cloud.fog.fill"
            palette = grayLightgray
        }
        else if (weather.contains("overcast")) {
            iconName = "smoke.fill"
            palette = gray
        }
        // put "fog" here so we get the fog icon for "freezing fog"
        else if (weather.contains("mist") || weather.contains("fog")) {
            iconName = "cloud.fog.fill"
            palette = grayLightgray
        }
        
        // MARK: rain
        // make "thunder" with rain or snow take precedence over just "thunder" on its own
        else if (weather.contains("thunder") && (weather.contains("rain") || weather.contains("snow"))) {
            iconName = "cloud.bolt.rain.fill"
            palette = whiteBlue
        }
        else if (weather.contains("thunder")) {
            iconName = "cloud.bolt.fill"
            palette = whiteGray
        }
        // check for "freezing" to make freezing rain take precedence over regular rain or drizzle
        else if (weather.contains("freezing")) {
            iconName = "cloud.sleet.fill"
            palette = whiteBlue
        }
        // "heavy rain" takes precedence over "rain"
        else if (weather.contains("heavy rain")) {
            iconName = "cloud.heavyrain.fill"
            palette = whiteBlue
        }
        else if (weather.contains("rain")) {
            iconName = "cloud.rain.fill"
            palette = whiteBlue
        }
        else if (weather.contains("drizzle")) {
            iconName = "cloud.drizzle.fill"
            palette = whiteBlue
        }
        
        // MARK: snow
        else if (weather.contains("snow")) {
            iconName = "cloud.snow"
            palette = grayWhite
        }
        else if (weather.contains("sleet") || weather.contains("ice pellets")) {
            iconName = "cloud.sleet.fill"
            palette = whiteBlue
        }
        else if (weather.contains("blizzard")) {
            iconName = "wind.snow"
            palette = grayWhite
        }
        
        // MARK: fallback to unknown
        else {
            iconName = "questionmark"
            palette = white
        }
        
        return UIImage(systemName: iconName, withConfiguration: UIImage.SymbolConfiguration(paletteColors: palette))
    }
}
