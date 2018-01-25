//
//  ConfigureViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 25..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import Eureka

class ConfigureViewController: FormViewController{
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    form +++ Section()
      <<< LabelRow(){
        $0.title = "로그아웃"
        }.onCellSelection({ (cell, row) in
          KOSession.shared().logoutAndClose(completionHandler: { (bool, error) in
            print(error)
          })
        })
      <<< LabelRow(){
        $0.title = "default로그아웃"
        }.onCellSelection({ (cell, row) in
          UserDefaults.standard.set(false, forKey: UDType.Login.rawValue)
        })
  }
}
