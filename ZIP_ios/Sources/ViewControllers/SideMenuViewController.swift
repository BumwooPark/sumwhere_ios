//
//  SideMenuViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 15..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Eureka


class SideMenuViewController: FormViewController{
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = .white
    form +++ Section("갈래말래"){
      var header = HeaderFooterView<MenuHeaderView>(.class)
      header.height = {200}
      $0.header = header
      }
      
      <<< LabelRow(){$0.title = "프로필 수정"}
      <<< LabelRow(){$0.title = "내 여행"}
      <<< LabelRow(){$0.title = "알림"}
      <<< LabelRow(){$0.title = "상점"}
      <<< LabelRow(){$0.title = "문의하기"}
      <<< LabelRow(){
        $0.title = "설정"
        $0.onCellSelection({[weak self] (cell, row) in
          guard let `self` = self else {return}
          self.present(ConfigureViewController(), animated: true, completion: nil)
        })
    }
  }
}
