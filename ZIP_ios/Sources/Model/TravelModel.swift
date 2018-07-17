//
//  TravelModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 17..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

struct TravelModel: Codable{
  let travel: Travel
  let travelType: TravelType
}

struct Travel: Codable{
  let id: Int
  let userId: Int
  let destination: Int
}

struct TravelType: Codable{
  let id: Int
  let destination: String
  let imageURL: String
}
