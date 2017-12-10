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


class MainViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.tableHeaderView = MainHeaderView()
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = tableView
    navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.title = "ZIP"
  }
}
