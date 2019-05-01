//
//  UserDefault+Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 2. 14..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation
import SwiftyUserDefaults


extension DefaultsKeys {
  static let token = DefaultsKey<String>("token",defaultValue: "")
  static let isLogin = DefaultsKey<Bool>("isLogin",defaultValue: false)
  static let isProfileSet = DefaultsKey<Bool>("isProfileSet",defaultValue: false)
  static let fcmToken = DefaultsKey<String?>("fcmToken")
}
