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
  let provider = AuthManager.sharedManager.provider
  let dataSources = RxTableViewSectionedReloadDataSource<MainViewModel>(
    configureCell: { (ds, tv, index, _) -> UITableViewCell in
    return UITableViewCell()
  })
  
  let mainHeaderView = MainHeaderView()
  
  let tableView: UITableView = {
    let tableView = UITableView()
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = tableView
    tableView.tableHeaderView = mainHeaderView
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "ZIP"
    
    mainHeaderView
      .travelButton
      .rx
      .tap
      .subscribe {[weak self] (event) in
      self?.navigationController?.pushViewController(TravelViewController(), animated: true)
    }
  }
  
//  func test(){
//    guard let data = UserDefaults.standard.data(forKey: UDType.TokenModel.rawValue) else {return}
//    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
//    log.info(unarchiver)
//    do{
//      let model = try unarchiver.decodeDecodable(TokenModel.self, forKey: UDType.TokenModel.rawValue)
//      log.info(model)
//    }catch let error{
//      log.error(error)
//    }
//  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
}
