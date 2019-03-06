//
//  ProfileViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 7..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import PopupDialog
import Moya

import JDStatusBarNotification

enum ProfileType{
  case nickname(value: String)
  case birthDay(value: String)
  case gender(value: String)
  case tripStyle(value: [TripStyle])
  case interest(value:[InterestModel])
  case character(value:[CharacterModel])
  case introText(value: String)
  case image(value: [UIImage?])
  case overLapCheck(value: Bool)
}

enum ValidateError: Error{
  case empty(message: String)
  case length(message: String)
  case notEqual(message: String)
  var message: String {
    switch self {
    case .empty(let message),.length(let message),.notEqual(let message):
      return message
    }
  }
}

