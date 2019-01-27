//
//  InputTrip.swift
//  ZIP_ios
//
//  Created by xiilab on 03/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import Foundation

struct InputTrip {
  let userId: Int64 = 0
  var tripTypeId: Int = 0
  var matchTypeId: Int = 0
  var startDate: String = String()
  var endDate: String = String()
  
  func ToModel() -> Trip{
    return Trip(id: 0, userId: 0,matchTypeId: self.matchTypeId, tripTypeId: self.tripTypeId, startDate: self.startDate, endDate: self.endDate)
  }
}
