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
  let matchTypeId: Int
  var concept: String
  let tripTypeId: Int
  var genderType: String
  var startDate: String
  var endDate: String
  
  func toInputModel() -> InputTrip{
    var trip = InputTrip()
    trip.concept = self.concept
    trip.tripTypeId = self.tripTypeId
    trip.endDate = self.endDate.toDate()?.date ?? Date()
    trip.startDate = self.startDate.toDate()?.date ?? Date()
    trip.genderType = self.genderType
    trip.matchTypeId = self.matchTypeId
    return trip
  }
}

struct TripType: Codable{
  let id: Int
  let trip: String
  let country: String
  let imageURL: String
}
