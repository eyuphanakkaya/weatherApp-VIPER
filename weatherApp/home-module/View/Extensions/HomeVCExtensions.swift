//
//  HomeVCExtensions.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 19.11.2023.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLists.prefix(7).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = weatherLists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
        cell.maxDegreeLabel.text = "\(Int(index.app_max_temp))°"
        cell.minDegreeLabel.text = "\(Int(index.app_min_temp))°"
        cell.windSpeedValueLabel.text = "\(index.wind_spd)"
        cell.windDirectionValueLabel.text = index.wind_cdir
        cell.humidityValueLabel.text = "\(index.rh)"
        // MARK: - image
        let imageUrl =  URL(string: "https://www.weatherbit.io/static/img/icons/\(index.weather.icon).png")
        cell.weatherValueImage.frame.size = CGSize(width: 25, height: 25)
        cell.weatherValueImage.kf.setImage(with: imageUrl)
        cell.backgroundColor = UIColor.clear
        // MARK: - date
        dateEditing(date: index.valid_date, label: cell.dayLabel)
       
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! WeatherTableViewCell
        cell.humidityImage.isHidden = false
        cell.humidityLabel.isHidden = false
        cell.humidityValueLabel.isHidden = false
        cell.windSpeedImage.isHidden = false
        cell.windSpeedLabel.isHidden = false
        cell.windSpeedValueLabel.isHidden = false
        cell.windDirectionImage.isHidden = false
        cell.windDirectionLabel.isHidden = false
        cell.windDirectionValueLabel.isHidden = false
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
    func dateEditing(date: String,label: UILabel) {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let apiDate = dateFormatter.date(from: date) {
            let calendar = Calendar.current
            if let nextDay = calendar.date(byAdding: .day, value: 1, to: today) {
                let nextDateString = dateFormatter.string(from: nextDay)
                tomorrow = nextDateString
            }
            if calendar.isDateInToday(apiDate) {
                label.text = "Today"
            } else {
                dateFormatter.dateFormat = "EE"
                let dayNameString = dateFormatter.string(from: apiDate)
                label.text = dayNameString
            }
        }
    }
}
extension HomeViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyLists.prefix(9).count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = hourlyLists[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyWeatherCell", for: indexPath) as! WeatherCollectionViewCell
        cell.weatherValueLabel.text = "\(Int(index.temp!))°"
        cell.weatherDayLabel.text = formatTime(index.timestamp_local!)
        let imageUrl =  URL(string: "https://www.weatherbit.io/static/img/icons/\(index.weather!.icon).png")
        cell.weatherImage.frame.size = CGSize(width: 25, height: 25)
        cell.weatherImage.kf.setImage(with: imageUrl)
        cell.backgroundColor = .clear
        return cell
    }
    func formatTime(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "h a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            
            let formattedTime = dateFormatter.string(from: date)
            return formattedTime
        }
        
        return ""
    }
}
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
