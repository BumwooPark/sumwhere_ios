//
//  FriendsViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 17..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

class FriendsViewController: UIViewController{
  
  var didUpdateConstraint = false
  let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    return scrollView
  }()
  
  let childViewController = RequestFriendsViewController()
  
  let rootView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.isScrollEnabled = false
    tableView.backgroundColor = .white
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addChildViewController(childViewController)
    view.addSubview(scrollView)
    scrollView.addSubview(rootView)
    rootView.addSubview(tableView)
    rootView.addSubview(childViewController.view)
    
    tableView.contentInset = UIEdgeInsets(top: childViewController.view.frame.height, left: 0, bottom: 0, right: 0)
    
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      scrollView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      rootView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      tableView.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview()
        make.top.equalTo(childViewController.view.snp.bottom)
      }
      
      childViewController.view.snp.makeConstraints { (make) in
        make.left.right.top.equalToSuperview()
        make.height.equalTo(150)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

class RequestFriendsViewController: UIPageViewController{
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .blue
  }
  
  override func willMove(toParentViewController parent: UIViewController?) {
    super.willMove(toParentViewController: parent)
    log.info("WillMove")
  }
  
  override func didMove(toParentViewController parent: UIViewController?) {
    super.didMove(toParentViewController: parent)
    log.info("didMove")
  }
}

