//
//  UserModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//


struct UserModel: Codable{
  let id: Int
  let email: String
  let password: String?
  var username: String?
  var joinType: String
  var gender: String?
  var nickname: String?
  let hasProfile: Bool
  let kakao_token: String?
  let facebook_token: String?
  let kakao_id: Int?
  let facebook_id: String?
  let point: Int
}


struct UserProfileModel: Codable {
  let id: Int
  let age: Int
  let characterType: [CharacterModel]
  let image1: String
  let image2: String
  let image3: String?
  let image4: String?
  let createAt: String
  let updateAt: String
}

struct UserWithProfile: Codable{
  let user: UserModel
  let profile: UserProfileModel
}
