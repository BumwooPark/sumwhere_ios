//
//  GPSMatchResultViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 23..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import CoreLocation
import RxCoreLocation
import RxSwift

class GPSMatchResultViewController: UIViewController{
  let disposeBag = DisposeBag()
  
  lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.requestWhenInUseAuthorization()
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.startUpdatingLocation()
    return manager
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    locationManager.rx
      .location
      .subscribe(onNext: { (location) in
        log.info(location)
      }).disposed(by: disposeBag)
  }
}
