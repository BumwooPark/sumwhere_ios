//
//  EventPageViewController.swift
//  ZIP_ios
//
//  Created by BumwooPark on 12/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

class EventPageViewController: UIViewController {
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .black
    return tableView
  }()
  
  override func loadView() {
    super.loadView()
    view = tableView
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
