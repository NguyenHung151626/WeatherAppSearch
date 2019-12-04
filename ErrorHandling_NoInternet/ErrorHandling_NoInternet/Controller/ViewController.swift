//
//  ViewController.swift
//  ErrorHandling_NoInternet
//
//  Created by MacMini2012 on 12/3/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import Reachability
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!

    let bag = DisposeBag()
    
    var weatherViewModel = WeatherViewModel(weather: Weather(temp: 1000, humidity: nil))
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        let observable = searchBar.rx.text.orEmpty
            .filter { $0.count > 4 }
        observable
            .bind(to: weatherViewModel.citySubject)
            .disposed(by: bag)
        
        weatherViewModel.temperatureSubject
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: bag)
        weatherViewModel.humiditySubject
            .bind(to: humidityLabel.rx.text)
            .disposed(by: bag)
        
    }

    

}


