//
//  MapCell.swift
//  ZIP_ios
//
//  Created by xiilab on 03/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import Eureka
import GoogleMaps

public class MapCell: Cell<Bool>, CellType{
    var didUpdateConstraint = false
    let mapView: GMSMapView = {
      let mapView = GMSMapView()
      let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
      mapView.isMyLocationEnabled = true
      mapView.settings.compassButton = true
      mapView.settings.myLocationButton = true
      mapView.camera = camera
      return mapView
    }()
  
  public override func setup() {
    super.setup()
    
    contentView.addSubview(mapView)
    height = {150}
    setNeedsUpdateConstraints()
    
  }
  public override func update() {
    super.update()
  }
  
  public override func updateConstraints() {
    if !didUpdateConstraint{
      mapView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
}

public final class MapRow: Row<MapCell>, RowType {
  required public init(tag: String?) {
    super.init(tag: tag)
    cellProvider = CellProvider<MapCell>()
  }
}
