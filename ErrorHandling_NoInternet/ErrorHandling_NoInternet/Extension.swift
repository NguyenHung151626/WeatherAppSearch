//
//  Extension.swift
//  ErrorHandling_NoInternet
//
//  Created by MacMini2012 on 12/3/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Reachability

extension ViewController {
    func callWeatherAPI(city: String) throws -> Observable<Weather> {
        let url = URLWeatherHead + city + URLWeatherTail
        switch reachability.connection {
        case .wifi, .cellular:
            return getResponse(url: url)
        case .unavailable:
            throw NetworkError.noInternetAvailable
        case .none:
            throw NetworkError.noInternetAvailable
        }
    }
    
    func getResponse(url: String) -> Observable<Weather> {
        let response = Observable.from([url])
            .map { urlString -> URL in
                let newString = urlString.replacingOccurrences(of: " ", with: "")
                return URL(string: "\(newString)")!
            }
            .map { url -> URLRequest in
                return URLRequest(url: url)
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .share(replay: 1)
        let temp = response
            .map { response, data -> Weather in
                if 200..<300 ~= response.statusCode {
                    let obj = try! JSONDecoder().decode(JSONObject.self, from: data)
                    return obj.main
                } else {
                    return Weather(temp: 1000, pressure: nil, humidity: 100, temp_min: 273, temp_max: 274)
                }
        }
        return temp
    }
    
}


