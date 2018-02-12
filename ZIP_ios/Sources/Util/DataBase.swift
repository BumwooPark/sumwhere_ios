//
//  DataBase.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 2. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import SQLite

class DataBase{
  
  var database: Connection?
  let id = Expression<Int64>("id")
  let serverID = Expression<Int64>("serverID")
  let nickname = Expression<String>("nickname")
  let text = Expression<String>("text")
  let chat: Table
  init(table: String) {
    self.chat = Table(table)
    do {
      let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
      database = try Connection("\(path)/db.sqlite3")
      try database!.run(self.chat.create(ifNotExists: true){ t in
        t.column(id, primaryKey: .autoincrement)
        t.column(serverID)
        t.column(nickname)
        t.column(text)
      })
    }catch let error{
      log.error(error)
    }
  }
  
  func insert(serverid: Int64, nickname: String, text: String){
    guard let db = database else {return}
    do{
      try db.run(chat.insert(self.serverID <- serverid, self.nickname <- nickname, self.text <- text))
    }catch let error{
      log.error(error)
    }
  }
  
  func selectAll(){
    guard let db = database else {return}
    do{
      let all = Array(try db.prepare(chat))
      log.info(all)
    }catch let error{
      log.error(error)
    }
  }
}



