//
//  SearchDestinationViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 28..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxDataSources
import RxCocoa
import RxSwift
import MXParallaxHeader


class SearchDestinationViewController: UIViewController, MatchTypeApplier{

  let viewModel = RegisterTripViewModel()
  private let disposeBag = DisposeBag()
  var didUpdateConstraint = false
  let headerView = TripSearchHeader()
  lazy var conceptVC = MatchConceptViewController(viewModel: viewModel)
  
  lazy var dataSources = RxTableViewSectionedReloadDataSource<SearchDestTVModel>(configureCell: {[weak self] (ds, tv, idx, item) -> UITableViewCell in
    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: DestinationSearchCell.self), for: idx) as! DestinationSearchCell
    cell.item = (item,self?.headerView.textField.text)
    return cell
  })
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.keyboardDismissMode = .interactive
    tableView.parallaxHeader.height = 130
    tableView.parallaxHeader.view = headerView
    tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
    tableView.alwaysBounceVertical = true
    tableView.backgroundColor = .white
    tableView.register(DestinationSearchCell.self, forCellReuseIdentifier: String(describing: DestinationSearchCell.self))
    return tableView
  }()
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.backgroundColor = .clear
    setStatusBarBackgroundColor(color: .clear)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.backgroundColor = .white
    
    let height = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
    tableView.parallaxHeader.minimumHeight = (height + 60)
    setStatusBarBackgroundColor(color: .white)
  }
    
  private func setStatusBarBackgroundColor(color: UIColor) {
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBar.backgroundColor = color
  }
  override func viewDidLoad() {
    _ = conceptVC
    view = tableView
    self.navigationController?.navigationBar.topItem?.title = String()
    hideKeyboardWhenTappedAround()
    
    headerView
      .textField
      .rx
      .text
      .orEmpty
      .ignore(String())
      .bind(to: viewModel.tripPlaceBinder)
      .disposed(by: disposeBag)

    tableView.rx
      .modelSelected(TripType.self)
      .subscribeNext(weak: self) { (weakSelf) -> (TripType) -> Void in
        return {type in
          weakSelf.viewModel.saver.accept(.place(model: type))
          weakSelf.navigationController?.pushViewController(weakSelf.conceptVC, animated: true)
        }
      }.disposed(by: disposeBag)
    
    viewModel.tripPlaceMapper
      .map{[SearchDestTVModel(items: $0)]}
      .bind(to: tableView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    view.setNeedsUpdateConstraints()
  }
  
  func matchIDApply(matchID: Int) {
    viewModel.inputModel.matchTypeId = matchID
  }
}
