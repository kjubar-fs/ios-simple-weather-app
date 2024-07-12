//
//  CityListViewController.swift
//  SimpleWeatherApp
//
//  Created by Kaleb Jubar on 2024-07-11.
//

import UIKit

class CityListViewController: UIViewController {
    var locationList: [WeatherAPIResponse]?
    var displayTempInC: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let list = locationList {
            print(list)
        }
        
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
    }
}

extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityListCell", for: indexPath) as? CityListViewTableCell,
              let location = locationList?[indexPath.row],
              let tempInC = displayTempInC else {
            return CityListViewTableCell()
        }
        
        // set the location name
        let city = location.location.name
        let region = location.location.region
        let country = location.location.country
        cell.locationLabel.text = city + ((!region.isEmpty && city.lowercased() != region.lowercased()) ? ", \(region)" : "") + ", \(country)"
        
        // set location weather
        let weatherDispName = location.current.condition.text
        let temp = tempInC ? location.current.temp_c : location.current.temp_f
        let tempUnit = tempInC ? "C" : "F"
        cell.weatherLabel.text = "\(weatherDispName)\n\(temp) \(tempUnit)"
        
        // set weather image
        cell.weatherIcon.image = ViewController.getWeatherIcon(weatherDispName)
        
        // make not selectable
        cell.selectionStyle = .none
        
        return cell
    }
}
