//
//  TripViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 19..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit

class TripViewController: UIViewController{
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "여행"
    self.view.backgroundColor = .white
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
}
