//
//  ViewController.swift
//  TableViewLoadImages
//
//  Created by MacMini2012 on 12/5/19.
//  Copyright © 2019 MGMVVMRxSwiftDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let bag = DisposeBag()
    
    var pixaImageViewModel = PixaImageViewModel(pixaImage: PixaImage(largeImageURL: nil, user: nil, pageURL: nil))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        
        //truyền keyword sang gọi API
        let searchClicked = searchBar.rx.searchButtonClicked
        let searchTextChanged = searchBar.rx.text.orEmpty
        let observable = searchClicked.withLatestFrom(searchTextChanged)
        
        //button trigger text
        observable
            .bind(to: pixaImageViewModel.searchKeywordSubject)
            .disposed(by: bag)
        bindTableView()
    }
    
    func bindTableView() {
        pixaImageViewModel.imageDataSubject
            .asObserver()
            //bind trả về là tableView.rx.items(cellIdentifier:, cellType:) return type là Disposable
            .bind(to: tableView.rx.items(cellIdentifier: "ImageTableViewCell", cellType: ImageTableViewCell.self)) {  _, pixaImage, cell in
                    cell.captionLabel.text = pixaImage.user
                    cell.pixaImageView.kf.setImage(with: URL(string: pixaImage.largeImageURL ?? ""),
                                                   placeholder: UIImage(named: "Default_Image"))
            }
            .disposed(by: bag)
        tableView.rx
            .modelSelected(PixaImage.self)
            .subscribe(onNext: { pixaImage in
                guard let urlstr = pixaImage.pageURL else {
                    return
                }
                guard let url = URL(string: urlstr) else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            .disposed(by: bag)

    }
}


