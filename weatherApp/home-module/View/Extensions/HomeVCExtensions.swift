//
//  HomeVCExtensions.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 19.11.2023.
//

import Foundation
import UIKit

// MARK: - table view
extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLists.prefix(7).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = weatherLists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
        
        cell.maxDegreeLabel.text = isDegree ? "\(Int(index.app_max_temp))°" : "\(celsiusToFahrenheit(Int(index.app_max_temp)))°"
        cell.minDegreeLabel.text = isDegree ? "\(Int(index.app_min_temp))°" : "\(celsiusToFahrenheit(Int(index.app_min_temp)))°"
        cell.windSpeedValueLabel.text = "\(index.wind_spd)"
        cell.windDirectionValueLabel.text = index.wind_cdir
        cell.humidityValueLabel.text = "\(index.rh)"
        // MARK: - image
        let imageUrl =  URL(string: "https://www.weatherbit.io/static/img/icons/\(index.weather.icon).png")
        cell.weatherValueImage.frame.size = CGSize(width: 25, height: 25)
        cell.weatherValueImage.kf.setImage(with: imageUrl)
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedRow == indexPath {
            return 125
        } else {
            return 55
        }
    }
 
}
// MARK: - collection view
extension HomeViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyLists.prefix(12).count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = hourlyLists[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyWeatherCell", for: indexPath) as! WeatherCollectionViewCell
        cell.weatherValueLabel.text = isDegree ?  "\(Int(index.temp!)) C°" : "\(Int(celsiusToFahrenheit(Int(index.temp!)))) F°"
        cell.weatherDayLabel.text = formatTime(index.timestamp_local!)
        let imageUrl =  URL(string: "https://www.weatherbit.io/static/img/icons/\(index.weather!.icon).png")
        cell.weatherImage.frame.size = CGSize(width: 25, height: 25)
        cell.weatherImage.kf.setImage(with: imageUrl)
        cell.backgroundColor = .clear
        return cell
    }

}
// MARK: - presenter to view protocol
extension HomeViewController : PresenterToViewHomeProtocol {
    func sendViewWeather(weatherList: Array<WeatherData>) {
        DispatchQueue.main.async { [self] in
            weatherLists = weatherList
            tableView.reloadData()
        }
 
    }
    func sendViewValueHourly(hourlyList: Array<HourlyWeatherData>) {
        DispatchQueue.main.async { [self] in
            hourlyLists  = hourlyList
            collectionView.reloadData()
        }
 
    }
}
