//
//  BannerModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 14/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

struct BannerModel: Codable{
  let id: Int
  let imageURL: String
  let createAt: String
  let updateAt: String
  enum CodingKeys: String, CodingKey {
    case id
    case imageURL = "image_url"
    case createAt = "create_at"
    case updateAt = "update_at"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    imageURL = try container.decode(String.self, forKey: .imageURL)
    createAt = try container.decode(String.self, forKey: .createAt)
    updateAt = try container.decode(String.self, forKey: .updateAt)
  }
}
