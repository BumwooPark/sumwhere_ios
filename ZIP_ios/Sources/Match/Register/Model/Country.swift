//
//  Country.swift
//  ZIP_ios
//
//  Created by park bumwoo on 10/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxDataSources

struct CountryWithPlace: Codable{
  let country: Country
  let tripPlace: TripPlace
}

struct Country: Codable {
  let id: Int
  let name: String
  let imageUrl: String
}

///DI용 나라와 여행지 네이밍위함
struct CountryWithTrip{
  let country: Country
  let tripPlace: CountryTripPlace
}

///DI용 시작날짜와 종료날짜
struct StartEndDate{
  let startDate: Date
  let endDate: Date
}

struct CountryModel: Codable{
  let result: [Result]
  
  struct Result: Codable {
    let id: Int
    let imageURL: URL
    let country_name: String
    
    enum CodingKeys: String, CodingKey {
      case id
      case imageURL = "image"
      case country_name
    }
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(Int.self, forKey: .id)
      imageURL = try URL(string: values.decode(String.self, forKey: .imageURL))!
      country_name = try values.decode(String.self, forKey: .country_name)
    }
  }
}
