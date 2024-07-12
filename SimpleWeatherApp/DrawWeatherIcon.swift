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
        let whiteYellow: [UIColor] = [.white, .systemYellow]
        let whiteBlue: [UIColor] = [.white, .systemBlue]
        let grayLightgray: [UIColor] = [.systemGray, .lightGray]
        let grayWhite: [UIColor] = [.systemGray, .white]
        let whiteGray: [UIColor] = grayWhite.reversed()
        
        // determine icon based on weather string contents
        if(weather.contains("sunny")) {
            return UIImage(systemName: "sun.max.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: yellow))
        } else if(weather.contains("partly cloudy")) {
            return UIImage(systemName: "cloud.sun.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: whiteYellow))
        } else if(weather.contains("rain")) {
            return UIImage(systemName: "cloud.rain.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: whiteBlue))
        } else if(weather.contains("overcast")) {
            return UIImage(systemName: "smoke.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: gray))
        } else if(weather.contains("clear")) {
            return UIImage(systemName: "sun.max.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: yellow))
        } else if(weather.contains("drizzle")) {
            return UIImage(systemName: "cloud.drizzle.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: whiteBlue))
        } else if(weather.contains("mist") || weather.contains("fog")) {
            return UIImage(systemName: "cloud.fog.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: grayLightgray))
        } else if(weather.contains("cloudy")) {
            return UIImage(systemName: "cloud.fog.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: grayLightgray))
        } else if(weather.contains("snow")) {
            return UIImage(systemName: "cloud.snow", withConfiguration: UIImage.SymbolConfiguration(paletteColors: grayWhite))
        } else if(weather.contains("sleet") || weather.contains("ice pellets")) {
            return UIImage(systemName: "cloud.sleet.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: whiteBlue))
        } else if(weather.contains("thunder")) {
            return UIImage(systemName: "cloud.bolt.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: whiteGray))
        } else if(weather.contains("blizzard")) {
            return UIImage(systemName: "wind.snow", withConfiguration: UIImage.SymbolConfiguration(paletteColors: grayWhite))
        } else if(weather.contains("heavy rain")) {
            return UIImage(systemName: "cloud.heavyrain.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: whiteBlue))
        } else {
            return UIImage(systemName: "questionmark", withConfiguration: UIImage.SymbolConfiguration(paletteColors: yellow))
        }
    }
}
