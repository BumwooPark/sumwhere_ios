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
import RxGesture


class SearchDestinationViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  var didUpdateConstraint = false
  let viewController: UIViewController
  
  var viewModel: SearchDestinationViewModel?
  
  lazy var textField: UITextField = {
    let textField = UITextField()
    textField.attributedPlaceholder = NSAttributedString(
      string: "여행지를 입력해 주세요",
      attributes: [.font : UIFont.NotoSansKRMedium(size: 15)])
    textField.font = UIFont.NotoSansKRMedium(size: 15)
    textField.setZIPClearButton()
    textField.clearButtonMode = .never
    textField.backgroundColor = .white
    textField.delegate = self
    return textField
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.rowHeight = 50
    tableView.separatorStyle = .none
    tableView.register(DestinationSearchCell.self, forCellReuseIdentifier: String(describing: DestinationSearchCell.self))
    return tableView
  }()
  
  lazy var dataSources = RxTableViewSectionedReloadDataSource<SearchDestTVModel>(configureCell: {[weak self]ds,tv,idx,item in
    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: DestinationSearchCell.self), for: idx) as! DestinationSearchCell
    cell.item = (item,self?.textField.text)
    cell.selectionStyle = .none
    return cell
  })
  
  init(viewController: UIViewController) {
    self.viewController = viewController
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    view.addSubview(textField)
    view.addSubview(tableView)
    view.backgroundColor = .white
    hideKeyboardWhenTappedAround()
    
    viewModel = SearchDestinationViewModel(text: textField.rx
      .text
      .asObservable())
    
    viewModel!.datas
      .asDriver()
      .drive(tableView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    tableView.rx
      .modelSelected(TripType.self)
      .asDriver()
      .flatMapLatest {[unowned self] (resultModel)  -> SharedSequence<DriverSharingStrategy, TripType> in
      let vc = self.viewController as! CreateTripViewController
        return vc.viewModel.serverTripValidate(model: resultModel)
          .asDriver(onErrorRecover: { (error) -> SharedSequence<DriverSharingStrategy, TripType> in
            vc.validationErrorPopUp(error: error)
            return Driver.just(TripType(id: 0, trip: String(), country: String(), imageURL: String()))
          })
      }.drive(onNext: {[weak self] (model) in
        if model.id != 0 {
          (self?.viewController as? CreateTripViewController)?.viewModel.dataSubject.onNext(.destination(model: model))
        }
      }).disposed(by: disposeBag)

    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      textField.snp.makeConstraints { (make) in
        make.left.right.top.equalToSuperview().inset(20)
        make.height.equalTo(50)
      }
      
      tableView.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview()
        make.top.equalTo(textField.snp.bottom)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let layer = CALayer()
    layer.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 2)
    layer.backgroundColor = #colorLiteral(red: 0.5212282456, green: 0.8123030511, blue: 1, alpha: 1)
    textField.layer.addSublayer(layer)
  }
}

extension SearchDestinationViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
}


