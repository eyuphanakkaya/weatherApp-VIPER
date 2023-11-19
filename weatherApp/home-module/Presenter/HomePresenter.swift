//
//  HomePresenter.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 18.11.2023.
//

import Foundation

class HomePresenter: ViewToPresenterHomeProtocol {
    var homeInteractor: PresenterToInteractorHomeProtocol?
    var homeView: PresenterToViewHomeProtocol?
    
    func weather(lat: String, lon: String, completion: @escaping (WeatherResult) -> Void) {
        homeInteractor?.fetchWeather(lat: lat, lon: lon, completion: completion)
    }
    
    func hourlyeWeathers(lat: String, lon: String, endDate: String, startDate: String) {
        homeInteractor?.hourlyWeather(lat: lat, lon: lon, endDate: endDate, startDate: startDate)
    }
        
}
extension HomePresenter : InteractorToPresenterHomeProtocol {
    func sendPresenterWeather(weatherList: Array<WeatherData>) {
        homeView?.sendViewWeather(weatherList: weatherList)
    }
    
    func sendPresenterHourly(hourlyList: Array<HourlyWeatherData>) {
        homeView?.sendViewValueHourly(hourlyList: hourlyList)
    }
    
    
}
