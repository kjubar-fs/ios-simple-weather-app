//
//  DrawWeatherIcon.swift
//  SimpleWeatherApp
//
//  Created by Berk Ozdemir on 2024-07-11.
//

import UIKit

extension ViewController{
    
    /// Given a weather code from the API, return a tuple with the display-friendly name and an icon.
    func lookupWeatherCode(_ code: Int) -> UIImage? {
        // if string contains ..... assign associated icon and color
        
        let weather = weatherDispName?.lowercased()
        
        if(weather?.contains("sunny") ?? false){
            return UIImage(systemName: "sun.max.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemYellow]))
        } else if(weather?.contains("partly cloudy") ?? false){
            return UIImage(systemName: "cloud.sun.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.white, .systemYellow]))
        } else if(weather?.contains("rain") ?? false){
            return UIImage(systemName: "cloud.rain.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.white, .systemBlue]))
        } else if(weather?.contains("overcast") ?? false){
            return UIImage(systemName: "smoke.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemGray]))
        } else if(weather?.contains("clear") ?? false){
            return UIImage(systemName: "sun.max.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemYellow]))
        } else if(weather?.contains("drizzle") ?? false){
            return UIImage(systemName: "cloud.drizzle.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.white, .systemBlue]))
        } else if(weather?.contains("mist") ?? false || weather?.contains("fog") ?? false){
            return UIImage(systemName: "cloud.fog.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemGray, .lightGray]))
        } else if(weather?.contains("cloudy") ?? false){
            return UIImage(systemName: "cloud.fog.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemGray, .lightGray]))
        } else if(weather?.contains("snow") ?? false){
            return UIImage(systemName: "cloud.snow", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemGray, .white]))
        } else if(weather?.contains("sleet") ?? false || weather?.contains("ice pellets") ?? false){
            return UIImage(systemName: "cloud.sleet.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.white, .systemBlue]))
        } else if(weather?.contains("thunder") ?? false){
            return UIImage(systemName: "cloud.bolt.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.white, .gray]))
        } else if(weather?.contains("blizzard") ?? false){
            return UIImage(systemName: "wind.snow", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.gray, .white]))
        } else if(weather?.contains("heavy rain") ?? false){
            return UIImage(systemName: "cloud.heavyrain.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.white, .cyan]))
        }  else {
            return UIImage(systemName: "questionmark", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemYellow]))
        }
    }
}
