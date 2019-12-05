//
//  CallImagesAPI.swift
//  TableViewLoadImages
//
//  Created by MacMini2012 on 12/5/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Reachability

extension PixaImageViewModel {
    func callPixaImageAPI(keyword: String) throws -> Observable<PixaImage> {
        let url = WeatherAPI.URLWeatherHead + city + WeatherAPI.URLWeatherTail
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
                    return Weather(temp: 1000, humidity: nil)
                }
        }
        return temp
    }
    
    func getResponse(url: String) -> Observable<Weather> {
        
    }
    
}

