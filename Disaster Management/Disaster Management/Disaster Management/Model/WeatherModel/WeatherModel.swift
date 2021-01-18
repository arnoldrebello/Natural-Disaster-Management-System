//
//  WeatherModel.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 6/7/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let description: String
    let humidity: Int
    let visibility: Int
    let latitude: Double
    let longitude: Double
    let windSpeed: Float
    let pressure: Float
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
