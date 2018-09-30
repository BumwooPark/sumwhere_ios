//
//  TripStyleModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 5..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

struct TripStyleModel: Codable{
  struct TripStyle: Codable{
    let id: Int
    let typeName: String
  }
  
  struct Element: Codable{
    let id: Int
    let styleId: Int
    let name: String
    let iconURL: String
  }
  
  let tripStyle: TripStyle
  let elements: [Element]
  var isOpend: Bool
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    elements = try values.decode([Element].self, forKey: .elements)
    tripStyle = try values.decode(TripStyle.self, forKey: .tripStyle)
    isOpend = false
  }

}
