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
        
        if(weatherDispName?.contains("Sunny") ?? false){
            return UIImage(systemName: "sun.max.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemYellow]))
        } else if(weatherDispName?.contains("Partly cloudy") ?? false || weatherDispName?.contains("Cloudy") ?? false){
            return UIImage(systemName: "cloud.sun.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.white, .systemYellow]))
        } else if(weatherDispName?.contains("rain") ?? false){
            return UIImage(systemName: "cloud.rain.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.white, .systemBlue]))
        }
        else if(weatherDispName?.contains("Overcast") ?? false){
            return UIImage(systemName: "smoke.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemGray]))
        }
        else if(weatherDispName?.contains("Clear") ?? false){
            return UIImage(systemName: "sun.max.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemYellow]))
        }
        else if(weatherDispName?.contains("drizzle") ?? false){
            return UIImage(systemName: "cloud.drizzle.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.white, .systemBlue]))
        }
        else if(weatherDispName?.contains("Mist") ?? false){
            return UIImage(systemName: "cloud.fog.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemGray, .lightGray]))
        }
        else if(weatherDispName?.contains("Cloudy") ?? false){
            return UIImage(systemName: "cloud.fog.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemGray, .lightGray]))
        }
        return UIImage(systemName: "sun.max.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemYellow]))
    }
}
