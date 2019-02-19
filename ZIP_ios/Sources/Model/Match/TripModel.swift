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
  let tripPlace: TripPlace
}

struct Trip: Codable{
  let id: Int
  let userId: Int
  let matchTypeId: Int
  let activity: String
  let region: String
  let tripPlaceId: Int
  var genderType: String
  var startDate: String
  var endDate: String
}

struct TripPlace: Codable{
  let id: Int
  let trip: String
  let discription: String
  let countryId: Int
  let imageURL: String
}
