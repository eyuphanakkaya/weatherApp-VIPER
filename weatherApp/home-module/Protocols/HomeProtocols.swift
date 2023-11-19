//
//  HomeProtocols.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 18.11.2023.
//

import Foundation

protocol ViewToPresenterHomeProtocol {
    var homeInteractor: PresenterToInteractorHomeProtocol? {get set}
    var homeView: PresenterToViewHomeProtocol? {get set}
    func weather(lat: String, lon: String,completion: @escaping(WeatherResult)-> Void)
    func hourlyeWeathers(lat: String,lon: String,endDate: String,startDate: String)
}
protocol PresenterToInteractorHomeProtocol {
    var interactorToPresenterProtocol : InteractorToPresenterHomeProtocol? {get set}
    func fetchWeather(lat: String, lon: String,completion: @escaping(WeatherResult)-> Void)
    func hourlyWeather(lat: String,lon: String,endDate: String,startDate: String)
}
protocol InteractorToPresenterHomeProtocol {
    func sendPresenterWeather(weatherList: Array<WeatherData>)
    func sendPresenterHourly(hourlyList: Array<HourlyWeatherData>)
}
protocol PresenterToViewHomeProtocol {
    func sendViewWeather(weatherList: Array<WeatherData>)
    func sendViewValueHourly(hourlyList: Array<HourlyWeatherData>)
}
protocol PresenterToRouterHomeProtocol {
    static func createModule(ref: HomeViewController)
}
