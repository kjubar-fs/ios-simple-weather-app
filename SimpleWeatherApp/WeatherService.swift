//
//  WeatherService.swift
//  SimpleWeatherApp
//
//  Created by Kaleb Jubar on 2024-07-11.
//

import UIKit

extension ViewController {
    func getWeatherForLocation(_ location: String) {
        // attempt to make the API call URL
        // if we can't make a URL for the API, return because we can't do anything
        guard let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=b8346bfb465743ed8f2172517241007&q=\(location)") else {
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
            
            // quit if API responds with not 200-299
            if let httpResp = response as? HTTPURLResponse {
                let respCode = httpResp.statusCode
                if (respCode < 200 || respCode >= 300) {
                    print("API responded with failure code: \(respCode) \(HTTPURLResponse.localizedString(forStatusCode: respCode))")
                    return
                }
            }
            
            // quit if we got no data
            guard let data = data else {
                return
            }
            
            // create a JSON decoder for reading the response
            let jsonDecoder = JSONDecoder()
            do {
                // attempt to decode the data
                let decodedData: WeatherAPIResponse = try jsonDecoder.decode(WeatherAPIResponse.self, from: data)
                
                if let apiErr = decodedData.error {
                    print("API error: \(apiErr.message)")
                    return
                }
                
                guard let apiCurrent = decodedData.current,
                      let apiLocation = decodedData.location else {
                    print("Unknown API error: response had no error code and also did not provide current weather info.")
                    return
                }
                let apiResp = WeatherAPIRespData(location: apiLocation, current: apiCurrent)
                
                // pull out weather info from data
                let code = apiResp.current.condition.code
                let weatherDispName = apiResp.current.condition.text
                let tempC = apiResp.current.temp_c
                let tempF = apiResp.current.temp_f
                let city = apiResp.location.name
                let region = apiResp.location.region
                let country = apiResp.location.country
                let locStr = city + ((!region.isEmpty && city.lowercased() != region.lowercased()) ? ", \(region)" : "") + ", \(country)"
                // save the location if it isn't in our list already
                if (!self.savedLocations.contains(apiResp)) {
                    self.savedLocations.append(apiResp)
                }
                
                // update the UI with the info
                // use the DispatchQueue to update on the main thread
                DispatchQueue.main.async {
                    self.setShowWeatherInfo(true)
                    self.setWeatherInfo(weatherCode: code, weatherString: weatherDispName, tempC: tempC, tempF: tempF, location: locStr)
                }
            } catch {
                // if we fail decoding, log the error
                print("Failed parsing API response to JSON: \(error)")
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
    let country: String}

struct APIError: Decodable {
    let code: Int
    let message: String
}

struct WeatherAPIRespData: Equatable {
    var location: LocationData
    var current: CurrentWeather
    
    /// Implementation of == for the Equatable protocol to use .contains() on our data list.
    /// Two WeatherAPIResponses are considered equal /only/ if they refer to the same location.
    static func == (lhs: WeatherAPIRespData, rhs: WeatherAPIRespData) -> Bool {
        return lhs.location.name == rhs.location.name &&
                lhs.location.region == rhs.location.region &&
                lhs.location.country == rhs.location.country
    }
}

struct WeatherAPIResponse: Decodable {
    let location: LocationData?
    let current: CurrentWeather?
    let error: APIError?
}
