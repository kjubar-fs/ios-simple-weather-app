//
//  CityListViewController.swift
//  SimpleWeatherApp
//
//  Created by Kaleb Jubar on 2024-07-11.
//

import UIKit

class CityListViewController: UIViewController {
    var locationList: [WeatherAPIResponse]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let list = locationList {
            print(list)
        }
    }
}
