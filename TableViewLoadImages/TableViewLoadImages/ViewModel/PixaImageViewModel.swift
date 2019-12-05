//
//  ImagesViewModel.swift
//  TableViewLoadImages
//
//  Created by MacMini2012 on 12/5/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PixaImageViewModel {
    let bag = DisposeBag()
    
    var pixaImage: PixaImage
    
    var searchKeywordSubject = BehaviorSubject<String>(value: "mountain")
    var imageDataSubject = BehaviorSubject<[PixaImage]>(value: [])
    
    init(pixaImage: PixaImage) {
        self.pixaImage = pixaImage
        gettingImagesData()
    }
    
    func gettingImagesData() {
        let observable = searchKeywordSubject
            .asObserver()
            .flatMap { keyword in
                return self.callPixaImageAPI(keyword: keyword)
            }
            .share()
        observable
            .bind(to: imageDataSubject)
            .disposed(by: bag)
    }
}
