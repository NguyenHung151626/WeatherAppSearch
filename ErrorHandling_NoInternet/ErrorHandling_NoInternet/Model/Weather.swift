//
//  WeatherData.swift
//  ErrorHandling_NoInternet
//
//  Created by MacMini2012 on 12/4/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    let temp: Double
    let pressure: Int?
    let humidity: Int?
    let temp_min: Double
    let temp_max: Double
    
    init(temp: Double, humidity: Int?) {
        self.temp = temp
        self.humidity = humidity
        self.pressure = nil
        self.temp_min = 0
        self.temp_max = 1001
    }
}

struct JSONObject: Decodable {
    let main: Weather
}

enum NetworkError: Error {
    case noInternetAvailable
}
