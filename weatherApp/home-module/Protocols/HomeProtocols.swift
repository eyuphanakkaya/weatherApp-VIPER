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
    func hourlyeWeathers(lat: String,lon: String,endDate: String,startDate: String,completion: @escaping(HourlyWeatherResult)-> Void)
}
protocol PresenterToInteractorHomeProtocol {
    var interactorToPresenterProtocol : InteractorToPresenterHomeProtocol? {get set}
    func fetchWeather(lat: String, lon: String,completion: @escaping(WeatherResult)-> Void)
    func hourlyWeather(lat: String,lon: String,endDate: String,startDate: String,completion: @escaping(HourlyWeatherResult)->Void)
}
protocol InteractorToPresenterHomeProtocol {
    func sendPresenterValue(weatherList: Array<WeatherData>)
    func sendPresenterValueSecond(hourlyList: Array<HourlyWeatherData>)
}
protocol PresenterToViewHomeProtocol {
    func sendViewValue(weatherList: Array<WeatherData>)
    func sendViewValueSecond(hourlyList: Array<HourlyWeatherData>)
}
protocol PresenterToRouterHomeProtocol {
    static func createModule(ref: HomeViewController)
}
