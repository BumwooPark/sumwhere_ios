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
  
  lazy var locationObserver = locationManager.rx
    .location
    .map{$0?.coordinate}
    .unwrap()
    .share()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    form +++ Section()
      <<< MapRow()
      <<< GALabelRow("location", {[weak self] (row) in
        guard let weakSelf = self else {return}
        weakSelf.locationObserver.take(1)
          .subscribeNext(weak: weakSelf, { (weakSelf) -> (CLLocationCoordinate2D) -> Void in
            return { coor in
              GMSGeocoder().reverseGeocodeCoordinate(coor, completionHandler: { (response, err) in
                row.value = response?.results()?.first?.lines?.first
                log.info(response?.firstResult())
                row.updateCell()
              })
            }
          }).disposed(by: weakSelf.disposeBag)
      })
      
      <<< GADateTimeInlineRow<Date>().cellSetup({ (cell, row) in
        cell.currentLabel.text = row.dateFormatter?.string(from: Date())
      }).onCellSelection({ (cell, row) in
        cell.currentLabel.text = row.dateFormatter?.string(from: row.value ?? Date())
      })
    
      +++ Section("활동")
      <<< TextAreaRow()
    

  }
}
