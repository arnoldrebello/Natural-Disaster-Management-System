//
//  WeatherManager.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 6/7/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import Foundation

import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=74765a644ddac4d0f8e539b5b800cc61&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let description = decodedData.weather[0].description
            let humidity = decodedData.main.humidity
            let visibility = decodedData.visibility
            let latitude = decodedData.coord.lat
            let longitude = decodedData.coord.lon
            let windSpeed = decodedData.wind.speed
            let pressure = decodedData.main.pressure
            
            let weather = WeatherModel(conditionId: id, cityName: String(name), temperature: temp,description: description,humidity: Int(humidity), visibility: Int(visibility), latitude: Double(latitude), longitude: Double(longitude), windSpeed: windSpeed, pressure: pressure  )
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}


