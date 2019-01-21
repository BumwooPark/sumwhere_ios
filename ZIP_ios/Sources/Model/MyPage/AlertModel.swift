//
//  AlertModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 21/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation

struct AlertModel: Codable {
  let id: Int
  let userId: Int
  var matchAlert: Bool
  var friendAlert: Bool
  var chatAlert: Bool
  var eventAlert: Bool
  
  
  func isAllTrue() -> Bool{
    return self.matchAlert && friendAlert && chatAlert && eventAlert
  }
  
  mutating func setAll(bool: Bool){
    self.matchAlert = bool
    self.friendAlert = bool
    self.chatAlert = bool
    self.eventAlert = bool
  }
}
