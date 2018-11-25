//
//  ProfileViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 22/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import Eureka

class ProfileViewController: FormViewController{
  override func viewDidLoad() {
    super.viewDidLoad()
    
    form +++ Section() { section in
      var header = HeaderFooterView<PHeaderView>(.class)
      header.height = {220}
      section.header = header
      }
      
      <<< TextRow()
      <<< TextRow()
    
  }
}

