//
//  FirstViewController.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 6/7/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var WeatherConditionImage: UIImageView!
    @IBOutlet weak var CityNameLabel: UILabel!
    @IBOutlet weak var TemperatureLabel: UILabel!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var CoordinatesLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var visibilityLabel: UILabel!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        SearchBar.delegate = self
    }
    
    

}

//MARK: - SearchFieldDelegate

extension WeatherViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.SearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let city = searchBar.text {
                weatherManager.fetchWeather(cityName: city)
            }
            
            searchBar.text = ""
        searchBar.resignFirstResponder()
        }
    

    
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.TemperatureLabel.text = weather.temperatureString+"°C"
            self.WeatherConditionImage.image = UIImage(systemName: weather.conditionName)
            self.CityNameLabel.text = weather.cityName
            self.descriptionLabel.text = weather.description
            self.pressureLabel.text = String(weather.pressure)
            self.humidityLabel.text = String(weather.humidity)
            self.windSpeedLabel.text = String(weather.windSpeed)
            self.CoordinatesLabel.text = String(format: "%.2f",weather.latitude)+","+String(format: "%.2f",weather.longitude)
            self.visibilityLabel.text = String(weather.visibility)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate


extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
