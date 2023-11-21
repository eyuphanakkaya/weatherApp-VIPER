//
//  HourlyWeatherEntity.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 19.11.2023.
//

import Foundation


struct HourlyWeatherResult: Codable {
    let data: [HourlyWeatherData]
}
struct HourlyWeatherData: Codable {
    let timestamp_local: String?
    let temp: Double?
    let weather: WeatherHourly?
}
struct WeatherHourly: Codable {
    let description: String
    let icon: String
}
