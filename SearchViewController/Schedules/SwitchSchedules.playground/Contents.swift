import UIKit
import RxSwift
import RxCocoa

// Start coding here

let elementsPerSecond = 1
let maxElements = 5
let replayedElements = 1
let replayDelay: TimeInterval = 3

let sourceObservable = Observable<Int>.interval(1.0 / Double(elementsPerSecond), scheduler: MainScheduler.instance).replay(1)
sourceObservable.subscribe(onNext: { data in
    print(data)
})
