//
//  CountryModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 3. 3..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

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
