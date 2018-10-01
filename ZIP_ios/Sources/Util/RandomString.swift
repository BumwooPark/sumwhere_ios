//
//  RandomString.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 27..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

func randomString(_ length: Int) -> String {
  
  let master = Array("abcdefghijklmnopqrstuvwxyz-ABCDEFGHIJKLMNOPQRSTUVWXYZ_123456789")
  var randomString = ""
  
  for _ in 1...length{
    
    let random = arc4random_uniform(UInt32(master.count))
    randomString.append(String(master[Int(random)]))
  }
  return randomString
}
