//
//  ViewController.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 18.11.2023.
//

import UIKit
import CoreLocation
import Kingfisher

class HomeViewController: UIViewController,CLLocationManagerDelegate {

    // MARK: -  components
    var selectedRow: IndexPath?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var highAndLowDegreeLabel: UILabel!
    @IBOutlet weak var weatherValueLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customViews: UIView!
    @IBOutlet weak var customCollectionView: UIView!
    var weatherLists = [WeatherData]()
    var hourlyList = [HourlyWeatherData]()
    var locationManager = CLLocationManager()
    var homePresenter: ViewToPresenterHomeProtocol?
    var todays: String!
    var tomorrow: String!
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        componentStyle()
        fetchLocation()
        HomeRouter.createModule(ref: self)
//        print(weatherLists)

    }
    // MARK: - Api caller
    func fetchWeatherApi(lat: String,lon: String) {
//        APICaller.getWeather(lat: lat, lon: lon) { [self] result in
//            weatherList.append(contentsOf: result.data)
//            cityNameLabel.text = result.city_name
//            for x in result.data {
//                degreesLabel.text = "\(Int(x.temp))°"
//                highAndLowDegreeLabel.text = "H: \(Int(x.app_max_temp)),L: \(Int(x.app_min_temp))"
//                weatherValueLabel.text = x.weather.description
//                fetchHourlyWeatherApi(lat: lat,lon: lon,endDate: "2023-11-20", startDate: "2023-11-19")
//            }
//            
//            tableView.reloadData()
//        }
        homePresenter?.weather(lat: lat, lon: lon, completion: { [self] result in
            cityNameLabel.text = result.city_name
            for x in result.data {
                degreesLabel.text = "\(Int(x.temp))°"
                highAndLowDegreeLabel.text = "H: \(Int(x.app_max_temp)),L: \(Int(x.app_min_temp))"
                weatherValueLabel.text = x.weather.description
                fetchHourlyWeatherApi(lat: lat,lon: lon,endDate: "2023-11-20", startDate: "2023-11-19")
            }
        })
    }

    func fetchHourlyWeatherApi(lat: String,lon: String,endDate: String,startDate: String){
        DispatchQueue.global().async { [self] in
            APICaller.getHourlyWeatherAddress(lat: lat, lon: lon, endDate: endDate, startDate: startDate) { result in
                    self.hourlyList.append(contentsOf: result.data)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    // MARK: - constraints style
    func componentStyle() {
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        // MARK: - table view style
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        // MARK: - custom views style
        customViews.layer.cornerRadius = 15
        customViews.layer.borderWidth = 0.2
        customViews.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        // MARK: - custom collection view style
        customCollectionView.layer.cornerRadius = 15
        customCollectionView.layer.borderWidth = 0.2
        customCollectionView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        // MARK: - collection view style
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
        collectionViewStyle()
    }
    func collectionViewStyle() {
        let design = UICollectionViewFlowLayout()
        design.scrollDirection = .horizontal
        design.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        design.itemSize = CGSize(width: 56, height: 128)
        design.minimumLineSpacing = 5
        design.minimumInteritemSpacing = 5
        
        collectionView.collectionViewLayout = design
    }
    // MARK: - location manager
    func fetchLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    // MARK: - Api caller and location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            fetchWeatherApi(lat: latitude.description, lon: longitude.description)
        }
    }
}
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
        let todayString = dateFormatter.string(from: today)
        todays = todayString
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
        return hourlyList.prefix(9).count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = hourlyList[indexPath.row]
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
    func sendViewValue(weatherList: Array<WeatherData>) {
        DispatchQueue.main.async { [self] in
            weatherLists = weatherList
            tableView.reloadData()
        }
 
    }
    
    func sendViewValueSecond(hourlyList: Array<HourlyWeatherData>) {
        
    }
    
    
}
