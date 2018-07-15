//
//  DemoTableViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 24/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import expanding_collection

class MainTableViewController: ExpandingTableViewController {
  
  fileprivate var scrollOffsetY: CGFloat = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 11.0, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    }
    
    
    
    
    tableView.register(TempCell.self, forCellReuseIdentifier: String(describing: TempCell.self))
    
    
    
  }
}


// MARK: Actions

extension MainTableViewController {
  
  @IBAction func backButtonHandler(_: AnyObject) {
    // buttonAnimation
    popTransitionAnimation()
  }
}

// MARK: UIScrollViewDelegate

extension MainTableViewController {
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TempCell.self), for: indexPath) as! TempCell
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < -25 , let navigationController = navigationController {
      popTransitionAnimation()
    }
    scrollOffsetY = scrollView.contentOffset.y
  }
}
