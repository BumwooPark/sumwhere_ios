//
//  CreateOnetimeViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 03/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMaps
import RxGoogleMaps
import RxCoreLocation
import Eureka

class CreateOneTimeViewController: FormViewController {
  
  
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
    
    
    form +++ Section()
      <<< MapRow()
      <<< GALabelRow()
      <<< GADateTimeInlineRow<Date>()
    
    locationManager.rx
      .location
      .map{$0?.coordinate}
      .unwrap()
      .subscribeNext(weak: self) { (weakSelf) -> (CLLocationCoordinate2D) -> Void in
        return { coordinate in
          let marker = GMSMarker(position: coordinate)
          log.info(coordinate)
//          marker.title = "hi"
//          marker.map = weakSelf.mapView
        }
      }.disposed(by: disposeBag)
    
  }
}
