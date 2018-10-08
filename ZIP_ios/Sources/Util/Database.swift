//
//  Database.swift
//  ZIP_ios
//
//  Created by xiilab on 08/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class Room: Object{
  @objc dynamic var id: Int64 = 0
  @objc dynamic var makerID: Int64 = 0
  @objc dynamic var roomDesc: String = String()
  @objc dynamic var createAt: String = String()
}

class Message: Object{
  @objc dynamic var id: Int64 = 0
  @objc dynamic var roomID: Int64 = 0
  @objc dynamic var messageType: String = String()
  @objc dynamic var data: Data = Data()
  @objc dynamic var createAt: String = String()
}
