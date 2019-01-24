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


class SearchDestinationViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  var didUpdateConstraint = false
  
  private let viewModel: RegisterTripViewModel
  let headerView = TripSearchHeader()
  
  
  lazy var dataSources = RxTableViewSectionedReloadDataSource<SearchDestTVModel>(configureCell: {[weak self] (ds, tv, idx, item) -> UITableViewCell in
    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: DestinationSearchCell.self), for: idx) as! DestinationSearchCell
//    cell.item = (item,self?.textField.text)
    return cell
  })
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.keyboardDismissMode = .interactive
    tableView.parallaxHeader.height = 100
    tableView.parallaxHeader.view = headerView
    tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
    tableView.alwaysBounceVertical = true
    tableView.backgroundColor = .white
    tableView.parallaxHeader.minimumHeight = 50
    tableView.register(DestinationSearchCell.self, forCellReuseIdentifier: String(describing: DestinationSearchCell.self))
    return tableView
  }()
  
  init(viewModel: RegisterTripViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    
    view = tableView
    hideKeyboardWhenTappedAround()
    
//    (55 - point.y)/55
    headerView
      .textField
      .rx
      .text
      .orEmpty
      .ignore(String())
      .bind(to: viewModel.tripPlaceBinder)
      .disposed(by: disposeBag)

    tableView.rx.modelSelected(TripType.self)
      .subscribeNext(weak: self) { (weakSelf) -> (TripType) -> Void in
        return {type in
          weakSelf.viewModel.saver.accept(RegisterTripViewModel.SaveType.place(model: type))
          weakSelf.viewModel.completeAction.onNext(())
        }
      }.disposed(by: disposeBag)
    
    viewModel.tripPlaceMapper
      .map{[SearchDestTVModel(items: $0)]}
      .bind(to: tableView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    

    view.setNeedsUpdateConstraints()
  }


  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
