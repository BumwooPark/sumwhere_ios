//
//  Country.swift
//  ZIP_ios
//
//  Created by park bumwoo on 10/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

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
