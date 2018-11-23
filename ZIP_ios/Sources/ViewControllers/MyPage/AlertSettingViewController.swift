//
//  AlertViewController.swift
//  ZIP_ios
//
//  Created by BumwooPark on 2018. 8. 23..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Eureka

class AlertSettingViewController: FormViewController{
  let enable = ["모든알림":true,"동행매칭알림":true,"친구요청알림":true,"채팅알림":true,"이벤트알림":true]
   let disable = ["모든알림":false,"동행매칭알림":false,"친구요청알림":false,"채팅알림":false,"이벤트알림":false]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    
    form +++
      Section("알림 설정")
      <<< SwitchRow("모든알림", { (row) in
        row.title = "모든알림"
        row.value = false
      }).cellSetup({ (cell, row) in
        cell.backgroundColor = .clear
        cell.height = {50}
        cell.switchControl.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
      }).onChange {[unowned self] row in
        if row.value ?? false{
          self.form.setValues(self.enable)
          
        }else{
          self.form.setValues(self.disable)
        }
        self.form.allSections[0].reload()
        row.updateCell()
      }
    
      <<< SwitchRow("동행매칭알림", { (row) in
        row.title = "동행매칭알림"
        row.value = false
      }).cellSetup({ (cell, row) in
        cell.backgroundColor = .clear
        cell.height = {50}
        cell.switchControl.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
      })
    
      <<< SwitchRow("친구요청알림", { (row) in
        row.title = "친구요청알림"
        row.value = false
      }).cellSetup({ (cell, row) in
        cell.backgroundColor = .clear
        cell.height = {50}
        cell.switchControl.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
      })
    
      <<< SwitchRow("채팅알림", { (row) in
        row.title = "채팅알림"
        row.value = false
      }).cellSetup({ (cell, row) in
        cell.backgroundColor = .clear
        cell.height = {50}
        cell.switchControl.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
      })
    
      <<< SwitchRow("이벤트알림", { (row) in
        row.title = "이벤트알림"
        row.value = false
      }).cellSetup({ (cell, row) in
        cell.backgroundColor = .clear
        cell.height = {50}
        cell.switchControl.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
      })
  }
}
