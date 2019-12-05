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

struct PixaImageAPI {
    static let URLHead = "https://pixabay.com/api/?key=14185511-626bf646b3fd0a73523fc6b66&q="
    static let URLTail = "&pretty=true&image_type=all"
}

extension PixaImageViewModel {
    func callPixaImageAPI(keyword: String) -> Observable<[PixaImage]> {
        let url = PixaImageAPI.URLHead + keyword + PixaImageAPI.URLTail
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
            .map { response, data -> [PixaImage] in
                if 200..<300 ~= response.statusCode {
                    let obj = try! JSONDecoder().decode(JSONObject.self, from: data)
                    return obj.hits
                } else {
                    return []
                }
        }
        return temp
    }
    
}

