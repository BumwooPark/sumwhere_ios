//
//  MapViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 15/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit
import GoogleMaps
import RxGoogleMaps
import RxCoreLocation
import RxSwift

class MapViewController: UIViewController {
  
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  
  lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.requestWhenInUseAuthorization()
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.startUpdatingLocation()
    return manager
  }()
  
  let mapView: GMSMapView = {
    let mapView = GMSMapView()
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    mapView.camera = camera
    return mapView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    log.info("init")
    view.addSubview(mapView)
    view.setNeedsUpdateConstraints()
    
    
    locationManager.rx
      .location
      .map{$0?.coordinate}
      .filterNil()
      .subscribeNext(weak: self) { (weakSelf) -> (CLLocationCoordinate2D) -> Void in
        return { coordinate in
          let marker = GMSMarker(position: coordinate)
          marker.title = "hi"
          marker.map = weakSelf.mapView
          
        }
      }.disposed(by: disposeBag)
    
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      mapView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
  
}
