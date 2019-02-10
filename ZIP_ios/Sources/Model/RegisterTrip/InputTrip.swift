//
//  InputTrip.swift
//  ZIP_ios
//
//  Created by xiilab on 03/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import Foundation

struct InputTrip {
  var tripName: String = String()
  let userId: Int64 = 0
  var tripTypeId: Int = 0
  var matchTypeId: Int = 0
  var genderType: String = "NONE"
  var concept: String = String()
  var startDate: String = String()
  var endDate: String = String()
  
  func ToModel() -> Trip{
    return Trip(id: 0, userId: 0,matchTypeId: self.matchTypeId,concept: self.concept,tripTypeId: self.tripTypeId, genderType: self.genderType, startDate: self.startDate, endDate: self.endDate)
  }
}
