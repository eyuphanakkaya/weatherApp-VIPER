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
    var hourlyLists = [HourlyWeatherData]()
    var locationManager = CLLocationManager()
    var homePresenter: ViewToPresenterHomeProtocol?
    var todays = ""
    var tomorrow = ""
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        componentStyle()
        fetchLocation()
        HomeRouter.createModule(ref: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    // MARK: - weather api caller
    func fetchWeatherApi(lat: String,lon: String) {
        homePresenter?.weather(lat: lat, lon: lon, completion: { [self] result in
            cityNameLabel.text = result.city_name
            for x in result.data {
                degreesLabel.text = "\(Int(x.temp))°"
                highAndLowDegreeLabel.text = "H: \(Int(x.app_max_temp)),L: \(Int(x.app_min_temp))"
                weatherValueLabel.text = x.weather.description
                homePresenter?.hourlyeWeathers(lat: lat, lon: lon, endDate: "2023-11-20", startDate: "2023-11-19")
            }
        })
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

