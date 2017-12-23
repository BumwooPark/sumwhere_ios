//
//  WriteViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 26..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Eureka
import ReSwift


final class WriteViewController: FormViewController{
  
  let disposeBag = DisposeBag()
 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "작성"
    self.view.backgroundColor = .white
    
    tableView.separatorStyle = .none
    form +++ Section()
      <<< WriterRow().cellSetup({ (cell, row) in
        cell.setup(title: "제목")
        cell.height = {return 100}
      })
      <<< WriterRow().cellSetup({ (cell, row) in
        cell.setup(title: "일자")
        cell.height = {return 100}
      })
      <<< WriterRow().cellSetup({ (cell, row) in
        cell.setup(title: "위치")
        cell.height = {return 100}
      })
      <<< WriterRow().cellSetup({ (cell, row) in
        cell.setup(title: "준비물")
        cell.height = {return 100}
      })
      <<< WriterRow().cellSetup({ (cell, row) in
        cell.setup(title: "환율")
        cell.height = {return 100}
      })
  
  }
}
