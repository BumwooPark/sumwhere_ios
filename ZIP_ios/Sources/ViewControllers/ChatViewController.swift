//
//  chatViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 18..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController{
  
  let tableView: UITableView = {
    let tableView = UITableView()
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "수다방"
    self.view = tableView
    
  }
}
