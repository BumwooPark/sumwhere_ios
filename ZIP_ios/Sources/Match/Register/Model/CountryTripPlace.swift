//
//  CountryTripPlaceModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 10/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

struct CountryTripPlace: Codable{
  let id: Int
  let trip: String
  let countryId: Int
  let imageURL: String
  let discription: String
}
