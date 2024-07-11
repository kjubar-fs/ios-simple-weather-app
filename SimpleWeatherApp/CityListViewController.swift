//
//  CityListViewController.swift
//  SimpleWeatherApp
//
//  Created by Kaleb Jubar on 2024-07-11.
//

import UIKit

class CityListViewController: UIViewController {
    var cityList: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let list = cityList {
            print(list)
        }
    }
}
