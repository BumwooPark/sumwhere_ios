//
//  UserModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

struct UserModel: Codable{
  let id: Int
  let email: String
  let password: String?
  var username: String?
  var gender: String?
  var nickname: String?
  let hasProfile: Bool
  let kakao_token: String?
  let facebook_token: String?
  let kakao_id: Int?
  let facebook_id: String?
  let point: Int
  var profile: ProfileModel?
}

struct ProfileModel: Codable{
  var birthday: String
  var tripType: [TripStyleModel]?
  var interestType: [InterestModel]?
  var characterType: [CharacterModel]?
  var introText: String?
  var image1: String
  var image2: String
  var image3: String
  var image4: String
  var image5: String
}
