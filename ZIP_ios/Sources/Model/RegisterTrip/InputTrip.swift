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
  var tripPlaceId: Int = 0
  var matchTypeId: Int = 0
  var genderType: String = "NONE"
  var region: String = String()
  var concept: String = String()
  var startDate: Date = Date()
  var endDate: Date = Date()
}
