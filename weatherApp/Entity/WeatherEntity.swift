//
//  WeatherEntity.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 18.11.2023.
//

import Foundation
import CoreData

struct WeatherResult: Codable {
    let city_name: String
    var data : [WeatherData]
}
struct WeatherData: Codable {
    var app_max_temp: Double
    var app_min_temp: Double
    var temp: Double
    let rh: Int
    let weather: Weather
    let wind_spd: Double
    let wind_cdir: String
}
struct Weather: Codable {
    let description: String
    let icon : String
}
