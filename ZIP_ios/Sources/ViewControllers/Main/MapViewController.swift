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
import RxCocoa
import AddressBookUI

class MapViewController: UIViewController {
  
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  
  private let searchButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "searchIcon.png"), for: .normal)
    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.84)
    button.layer.cornerRadius = 47/2
    button.contentHorizontalAlignment = .left
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 27, bottom: 0, right: 0)
    return button
  }()
  
  lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.requestWhenInUseAuthorization()
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.startUpdatingLocation()
    return manager
  }()
  
  private let mapView: GMSMapView = {
    let mapView = GMSMapView()
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    mapView.isMyLocationEnabled = true
    mapView.settings.compassButton = true
    mapView.settings.myLocationButton = true
    mapView.camera = camera
    return mapView
  }()
  
  let submitButton: UIButton = {
    let button = UIButton()
    button.setTitle("설정 완료", for: .normal)
    button.titleLabel?.font = UIFont.AppleSDGothicNeoSemiBold(size: 20)
    button.layer.cornerRadius = 10
    button.backgroundColor = #colorLiteral(red: 0.3662652075, green: 0.6248043776, blue: 0.9962931275, alpha: 1)
    return button
  }()
  
  lazy var submitMarker: GMSMarker = {
    let marker = GMSMarker()
    marker.appearAnimation = .pop
    marker.map = self.mapView
    return marker
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(mapView)
    view.addSubview(submitButton)
    view.addSubview(searchButton)
    view.setNeedsUpdateConstraints()
    
    self.navigationController?.navigationBar.isTranslucent = false
    
    mapView.rx.didChange.asDriver()
      .drive(onNext: {[weak self] location in
        self?.submitMarker.position = location.target
      })
      .disposed(by: disposeBag)

    title = "경기도"
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      mapView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      submitButton.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(17)
        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(13)
        make.height.equalTo(57)
      }
      
      searchButton.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(18.5)
        make.top.equalToSuperview().inset(21)
        make.height.equalTo(47)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
  
}
