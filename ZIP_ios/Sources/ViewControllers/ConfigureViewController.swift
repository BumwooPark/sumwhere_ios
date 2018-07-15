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
          tokenObserver.onNext("")
        })
      <<< LabelRow(){
        $0.title = "default로그아웃"
        }.onCellSelection({ (cell, row) in
        })
  }
}
