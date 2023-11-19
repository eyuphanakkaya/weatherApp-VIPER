//
//  APICaller.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 18.11.2023.
//

import Foundation
import Alamofire

class NetworkConstants {
    public static var shared = NetworkConstants()
    public var weatherAPIKey : String {
        get {
            return "3ad2b09d81a545688ff128d904ca1363"
        }
    }
    public static func weatherAddress(lat: String,lon: String) -> String {
        return "https://api.weatherbit.io/v2.0/forecast/daily?&lat=\(lat)&lon=\(lon)&key=\(NetworkConstants.shared.weatherAPIKey)"
        
    }
    public static func hourlyWeatherAddress(lat: String,lon: String,endDate: String,startDate: String) -> String {
        return "https://api.weatherbit.io/v2.0/history/hourly?lat=\(lat)&lon=\(lon)&start_date=\(startDate)&end_date=\(endDate)&tz=local&key=\(NetworkConstants.shared.weatherAPIKey)"
    }
}
class APICaller {
    static func getWeather(lat: String, lon: String,completion: @escaping(WeatherResult)-> Void) {
        AF.request(NetworkConstants.weatherAddress(lat: lat, lon: lon),method: .get).response { response in
            if let data = response.data {
                do {
                    let weather = try JSONDecoder().decode(WeatherResult.self, from: data)
                    completion(weather)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    static func getHourlyWeatherAddress(lat: String,lon: String,endDate: String,startDate: String,completion: @escaping(HourlyWeatherResult)-> Void) {
        AF.request(NetworkConstants.hourlyWeatherAddress(lat: lat, lon: lon, endDate: endDate, startDate: startDate),method: .get).response { response in
            if let data = response.data {
                do {
                    let hourlyWeather = try JSONDecoder().decode(HourlyWeatherResult.self, from: data)
                    
                    completion(hourlyWeather)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
