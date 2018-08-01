//
//  MyTripViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 1..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

final class MyTripViewController: UIViewController{
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(MyTripCell.self, forCellReuseIdentifier: String(describing: MyTripCell.self))
    tableView.backgroundColor = .white
    return tableView
  }()
  
  let dataSources = RxTableViewSectionedReloadDataSource<TravelViewModel>(configureCell: {ds, tv, idx, item in
    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: MyTripCell.self), for: idx) as! MyTripCell
    return cell
  })
  
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = tableView
  }
}
