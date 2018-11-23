//
//  RewardPurchase.swift
//  ZIP_ios
//
//  Created by xiilab on 23/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import Firebase

protocol RewardAction{
  func Action()
}

final class RewardPurchase: NSObject{
  
  enum RewardType{
    case Friends(title: String, reward: Int, action: RewardAction)
    case Attendance(enable: String, disable: String, reward: Int, action: RewardAction)
    case Advertisement(title: String, reward: Int, action: RewardAction)
  }

  let rewardType: RewardType
  
  init(rewardType: RewardType) {
    self.rewardType = rewardType
    super.init()
  }
  
  func action(){
    switch rewardType{
    case let .Advertisement(title, reward, action):
      action.Action()
    case let .Attendance(enable, disable, reward, action):
      action.Action()
    case let .Friends(title, reward, action):
      action.Action()
    }
  }
}
