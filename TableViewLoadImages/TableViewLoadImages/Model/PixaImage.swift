//
//  PixaBaySearchImage.swift
//  TableViewLoadImages
//
//  Created by MacMini2012 on 12/5/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation

struct JSONObject: Decodable {
    let totalHits: Int
    let hits: [PixaImage]
}

struct PixaImage: Decodable {
    let largeImageURL: String?
    let user: String?
    let pageURL: String?
}
