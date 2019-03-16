//
//  MatchHistoryModel.swift
//  ZIP_ios
//
//  Created by xiilab on 06/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation

struct MatchHistory: Codable{
  let id: Int
  let userId: Int
  let tripId: Int
  let toUserId: Int
  let toTripId: Int
  let accept: Bool
  let createAt: String
}

struct MatchHistoryModel: Codable{
  let trip: Trip
  let tripPlace: TripPlace
  let profile: UserProfileModel
  let user: UserModel
}
