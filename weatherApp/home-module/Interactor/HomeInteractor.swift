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
    
    func hourlyWeather(lat: String, lon: String, endDate: String, startDate: String) {
        AF.request(NetworkConstants.hourlyWeatherAddress(lat: lat, lon: lon, endDate: endDate, startDate: startDate),method: .get).response { response in
            guard let data = response.data else {
                print("selam ********")
                return}
                do {
                    let hourlyWeather = try JSONDecoder().decode(HourlyWeatherResult.self, from: data)
                    self.interactorToPresenterProtocol?.sendPresenterHourly(hourlyList: hourlyWeather.data)
                } catch {
                    print(error.localizedDescription)
                }
        }
    }
    
    func fetchWeather(lat: String, lon: String, completion: @escaping (WeatherResult) -> Void) {
        AF.request(NetworkConstants.weatherAddress(lat: lat, lon: lon),method: .get).response { response in
            guard let data = response.data else {
                if let value = self.loadWeatherDataFromUserDefaults() {
                    self.interactorToPresenterProtocol?.sendPresenterWeather(weatherList: value.data)
                    Globals.shared.valuesOne = false
                    completion(value)
                }
                return}
                do {
                    let weather = try JSONDecoder().decode(WeatherResult.self, from: data)
                    self.interactorToPresenterProtocol?.sendPresenterWeather(weatherList: weather.data)
                    Globals.shared.valuesOne = true
                    completion(weather)
                } catch {
                    print(error.localizedDescription)
                }
        }
    }
    func loadWeatherDataFromUserDefaults() -> WeatherResult? {
        // UserDefaults nesnesini al
        let userDefaults = UserDefaults.standard

        // UserDefaults'ten veriyi çek
        if let savedData = userDefaults.data(forKey: "weatherDataKey") {
            // JSON'dan WeatherResult tipine dönüştür
            let decoder = JSONDecoder()
            return try? decoder.decode(WeatherResult.self, from: savedData)
        }

        return nil
    }
    
}
