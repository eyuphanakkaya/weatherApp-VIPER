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
    
    func hourlyeWeathers(lat: String, lon: String, endDate: String, startDate: String, completion: @escaping (HourlyWeatherResult) -> Void) {
        homeInteractor?.hourlyWeather(lat: lat, lon: lon, endDate: endDate, startDate: startDate, completion: completion)
    }
        
}
extension HomePresenter : InteractorToPresenterHomeProtocol {
    func sendPresenterValue(weatherList: Array<WeatherData>) {
        homeView?.sendViewValue(weatherList: weatherList)
    }
    
    func sendPresenterValueSecond(hourlyList: Array<HourlyWeatherData>) {
        homeView?.sendViewValueSecond(hourlyList: hourlyList)
    }
    
    
}
