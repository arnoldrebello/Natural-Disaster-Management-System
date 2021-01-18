//
//  WeatherData.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 6/7/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coord
    let visibility: Double
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let pressure: Float
    let humidity: Float

}

struct Weather: Codable {
    let description: String
    let id: Int
}
struct Coord: Codable {
    let lat: Float
    let lon: Float
}

struct Wind: Codable {
    let speed: Float
}


