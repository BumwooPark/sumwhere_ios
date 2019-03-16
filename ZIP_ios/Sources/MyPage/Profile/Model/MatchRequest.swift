//
//  MatchRequest.swift
//  ZIP_ios
//
//  Created by xiilab on 07/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation

struct MatchRequstModel: Codable{
  let tripPlaceId: Int
  let tripId: Int
  let toTripId: Int
  let toUserId: Int
}
