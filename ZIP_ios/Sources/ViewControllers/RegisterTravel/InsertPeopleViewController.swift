//
//  InsertPeopleViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 29..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxCocoa
import RxSwift
import RxDataSources
import DZNEmptyDataSet

final class InsertPeopleViewController: UIViewController{
  
  var didUpdateConstraint = false
  let viewController: UIViewController
  private let disposeBag = DisposeBag()
  private let dataSources = RxTableViewSectionedReloadDataSource<FriendsViewModel>(configureCell: {ds,tv,idx,item in
    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: FriendsCell.self), for: idx) as! FriendsCell
    return cell
  })
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "동행인원"
    label.font = UIFont.NotoSansKRMedium(size: 15)
    return label
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.register(FriendsCell.self, forCellReuseIdentifier: String(describing: FriendsCell.self))
    tableView.emptyDataSetSource = self
    return tableView
  }()
  
  init(viewController: UIViewController) {
    self.viewController = viewController
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(titleLabel)
    view.addSubview(tableView)
    
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(50)
        make.centerX.equalToSuperview()
      }
      
      tableView.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(10)
        make.left.right.bottom.equalToSuperview()
      }
    
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

extension InsertPeopleViewController: DZNEmptyDataSetSource{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "등록된 친구가 없습니다.", attributes: [.font : UIFont.NotoSansKRMedium(size: 15)])
  }
}
