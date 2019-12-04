//
//  WeatherViewModel.swift
//  ErrorHandling_NoInternet
//
//  Created by MacMini2012 on 12/4/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Reachability

class WeatherViewModel {
    let reachability = try! Reachability()
    let bag = DisposeBag()
    var weatherNil = Weather(temp: 1000, humidity: nil)
    
    //Ref to the model
    var weather: Weather
    
    var citySubject = BehaviorSubject<String>(value: "")
    var temperatureSubject = BehaviorSubject<String>(value: "")
    var humiditySubject = BehaviorSubject<String>(value: "")
    init(weather: Weather) {
        self.weather = weather
        analyzingData()
    }
    
    func analyzingData() {
        let observable = citySubject
            .asObservable()
            .flatMap { city -> Observable<Weather> in
                var weatherTemp = self.weatherNil
                do {
                    return try self.callWeatherAPI(city: city)
                } catch NetworkError.noInternetAvailable {
                    weatherTemp = self.weatherNil
                }
                return Observable.just(weatherTemp)
            }
        observable
            .map { weather -> String in
                var result = ""
                if weather.temp == 1000 {
                    result = "Nhiệt độ: " + "None"
                } else {
                    result = "Nhiệt độ: " + "\(Int(weather.temp - 273))" + " độ C"
                }
                return result
            }
            .bind(to: temperatureSubject)
            .disposed(by: bag)
        observable
            .map { weather -> String in
                guard let humid = weather.humidity else {
                    return "Độ ẩm: " + "None"
                }
                return "Độ ẩm: " + "\(humid)" + " %"
            }
            .bind(to: humiditySubject)
            .disposed(by: bag)
    }
}
