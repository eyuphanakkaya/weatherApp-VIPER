//
//  HomeInteractor.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 18.11.2023.
//

import Foundation
import Alamofire

class HomeInteractor: PresenterToInteractorHomeProtocol {
    var interactorToPresenterProtocol: InteractorToPresenterHomeProtocol?
    
    func hourlyWeather(lat: String, lon: String, endDate: String, startDate: String, completion: @escaping (HourlyWeatherResult) -> Void) {
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
    
    func fetchWeather(lat: String, lon: String, completion: @escaping (WeatherResult) -> Void) {
        AF.request(NetworkConstants.weatherAddress(lat: lat, lon: lon),method: .get).response { response in
            if let data = response.data {
                do {
                    let weather = try JSONDecoder().decode(WeatherResult.self, from: data)
                    self.interactorToPresenterProtocol?.sendPresenterValue(weatherList: weather.data)
                    completion(weather)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
 
  
}
