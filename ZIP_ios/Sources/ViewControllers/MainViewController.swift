//
//  MainViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 10..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.tableHeaderView = MainHeaderView()
    tableView.backgroundColor = .white
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = tableView
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.title = "ZIP"

  }
}
