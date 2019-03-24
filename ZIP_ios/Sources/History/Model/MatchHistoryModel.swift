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
  let state: String
  let createdAt: String
}

struct MatchHistoryModel: Codable{
  let matchHistory: MatchHistory
  let trip: Trip
  let tripPlace: TripPlace
  let profile: UserProfileModel
  let user: UserModel
}
