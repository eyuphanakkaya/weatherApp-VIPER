//
//  Globals.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 19.11.2023.
//

import Foundation

class Globals {
    public static var shared = Globals()
    static var weatherList = [WeatherData]()
    static var hourlyList = [HourlyWeatherData]()
}
