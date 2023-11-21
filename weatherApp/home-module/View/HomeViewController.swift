//
//  ViewController.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 18.11.2023.
//

import UIKit
import CoreLocation
import Kingfisher
import CoreData

class HomeViewController: UIViewController,CLLocationManagerDelegate {
    
    // MARK: -  components
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lowDegreeLabel: UILabel!
    @IBOutlet weak var highDegreeLabel: UILabel!
    @IBOutlet weak var weatherValueLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customViews: UIView!
    @IBOutlet weak var customCollectionView: UIView!
    var isDegree = true
    var weatherLists = [WeatherData]()
    var weatherList2 = [WeatherData]()
//    {
//        didSet {
//            sendViewWeather(weatherList: weatherList2)
//        }
//    }
    var hourlyLists = [HourlyWeatherData]()
    var locationManager = CLLocationManager()
    var homePresenter: ViewToPresenterHomeProtocol?
    var selectedRow: IndexPath?
    var dateFormatter = DateFormatter()
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        componentStyle()
        fetchLocation()
        HomeRouter.createModule(ref: self)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            let result =  self.loadWeatherDataFromUserDefaults()
            //             print(result)
        }
        
    }
    // MARK: - button actions
    @IBAction func changeDegreeStatusButton(_ sender: Any) {
        isDegree.toggle()
        degreesLabel.text = isDegree ? "\(Int(weatherLists[0].temp)) C°" : "\(Int(celsiusToFahrenheit(Int(weatherLists[0].temp)))) F°"
        highDegreeLabel.text = isDegree ? "H: \(Int(weatherLists[0].app_max_temp)) C°" : "H: \(Int(celsiusToFahrenheit(Int(weatherLists[0].app_max_temp)))) F°"
        lowDegreeLabel.text = isDegree ? "L: \(Int(weatherLists[0].app_min_temp)) C°" : "L: \(Int(celsiusToFahrenheit(Int(weatherLists[0].app_min_temp)))) F°"
        tableView.reloadData()
        collectionView.reloadData()
        
    }
    // MARK: - celsiusToFahrenheit settings
    func celsiusToFahrenheit(_ celsius: Int) -> Int {
        return (celsius * 9/5) + 32
    }
    // MARK: - days settings
    func getTodayAndTomorrow() -> (today: String, tomorrow: String) {
        let today = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let todayString = dateFormatter.string(from: today)
        
        let calendar = Calendar.current
        
        if let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: today) {
            let tomorrowString = dateFormatter.string(from: tomorrowDate)
            return (todayString, tomorrowString)
        } else {
            fatalError("error")
        }
    }
    
    func formatTime(_ dateString: String) -> String {
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
    // MARK: - background Value
    func backgroundValue() {
        DispatchQueue.main.async {
            if self.weatherLists[0].weather.description.lowercased().contains("clouds") {
                self.view.backgroundColor = #colorLiteral(red: 0.1116948351, green: 0.1420827508, blue: 0.1714244187, alpha: 1)
            } else if self.weatherLists[0].weather.description.lowercased().contains("rain"){
                self.view.backgroundColor = #colorLiteral(red: 0.0683510676, green: 0.2588295937, blue: 0.5978077054, alpha: 1)
            } else if self.weatherLists[0].weather.description.lowercased().contains("snow") {
                self.view.backgroundColor = #colorLiteral(red: 0.1116948351, green: 0.1420827508, blue: 0.1714244187, alpha: 1)
            } else if self.weatherLists[0].weather.description.lowercased().contains("sleet") {
                self.view.backgroundColor = #colorLiteral(red: 0.1922393739, green: 0.6801093221, blue: 0.8735067844, alpha: 1)
            } else {
                self.view.backgroundColor = #colorLiteral(red: 0.1922393739, green: 0.6801093221, blue: 0.8735067844, alpha: 1)
            }
        }
    }
    // MARK: - weather api caller
    func fetchWeatherApi(lat: String,lon: String) {
        homePresenter?.weather(lat: lat, lon: lon, completion: { [self] result in
            cityNameLabel.text = result.city_name
            degreesLabel.text = "\(Int(result.data[0].temp)) C°"
            highDegreeLabel.text = "H: \(Int(result.data[0].app_max_temp))°"
            lowDegreeLabel.text = "L: \(Int(result.data[0].app_min_temp))°"
            weatherValueLabel.text = result.data[0].weather.description
            self.weatherList2 = result.data
            saveDataToUserDefaults(result: result)

            homePresenter?.hourlyeWeathers(lat: lat, lon: lon, endDate: getTodayAndTomorrow().tomorrow, startDate: getTodayAndTomorrow().today)
            //                backgroundValue()
        })
    }
    func saveDataToUserDefaults(result: WeatherResult) {
        // UserDefaults nesnesini al
        let userDefaults = UserDefaults.standard
        
        // Veriyi Codable olarak JSON'a dönüştür
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(result) {
            // Dönüştürülmüş veriyi UserDefaults'e kaydet
            userDefaults.set(encodedData, forKey: "weatherDataKey")
            
            // Değişiklikleri kaydet
            userDefaults.synchronize()
        }
    }
    func loadWeatherDataFromUserDefaults() -> WeatherResult? {
        // UserDefaults nesnesini al
        let userDefaults = UserDefaults.standard
        
        // UserDefaults'ten veriyi çek
        if let savedData = userDefaults.data(forKey: "weatherDataKey") {
            // JSON'dan WeatherResult tipine dönüştür
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(WeatherResult.self, from: savedData) {
                return decodedData
            }
        }
        
        return nil
    }
    
    //    func coreDataActions(result : WeatherResult) {
    //          let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //          let context = appDelegate.persistentContainer.viewContext
    //        var weatherResult = Weather_Result(context: context)
    ////        weatherResult.data = result.data
    //        var deneme = Weather_Data(context: context)
    //        deneme.myWeatherResult
    ////        saveWeather.cityName = result.city_name
    ////        saveWeather.data = result.data as NSObject as! [Weather_Data]
    //          do {
    //            try context.save()
    //            self.getData()
    //          }catch {
    //            print("error")
    //          }
    //        }
    //
    //    func getData() {
    //
    //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //        let context = appDelegate.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather_Result")
    //        fetchRequest.returnsObjectsAsFaults = false
    //        do {
    //            let result = try context.fetch(fetchRequest)
    //            if result.count > 0 {
    //                for results in result as! [NSManagedObject] {
    //                    print(results.value(forKey: "cityName"))
    //                    print(results.value(forKey: "data"),"---------------------")
    //
    //                }
    //            }
    //
    //        }catch {
    //            print("error")
    //        }
    ////        self.personTableview.reloadData()
    ////        print(nameArray)
    ////        print(ageArray)
    //    }
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


