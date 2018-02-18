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
  static let token = DefaultsKey<String>("token")
  static let isLogin = DefaultsKey<Bool>("isLogin")
  static let isProfileSet = DefaultsKey<Bool>("isProfileSet")
}
