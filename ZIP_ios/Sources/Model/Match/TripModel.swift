//
//  TripModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 17..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

struct TripModel: Codable{
  let trip: Trip
  let tripType: TripType
}

struct Trip: Codable{
  let id: Int
  let userId: Int
  let tripTypeId: Int
  let startDate: String
  let endDate: String
  let expired: Bool
}

struct TripType: Codable{
  let id: Int
  let trip: String
  let country: String
  let imageURL: String
}
