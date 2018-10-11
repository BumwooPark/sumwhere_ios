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
import DropDown


class SearchDestinationViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  var didUpdateConstraint = false
  private let viewModel: RegisterTripViewModel
  
  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "backButton.png").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = .black
    return button
  }()
  
  lazy var textField: UITextField = {
    let textField = UITextField()
    textField.attributedPlaceholder = NSAttributedString(
      string: "여행지를 입력해 주세요",
      attributes: [.font : UIFont.AppleSDGothicNeoMedium(size: 15)])
    textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
    textField.leftViewMode = .always
    textField.font = .AppleSDGothicNeoMedium(size: 15)
    textField.setZIPClearButton()
    textField.clearButtonMode = .never
    textField.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
    textField.delegate = self
    return textField
  }()
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
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
  
  init(viewModel: RegisterTripViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    view.addSubview(textField)
    view.addSubview(tableView)
    view.addSubview(backButton)
    view.backgroundColor = .white
    hideKeyboardWhenTappedAround()
    
//    tableView.rx
//      .modelSelected(TripType.self)
//      .asDriver()
//      .flatMapLatest {[unowned self] (resultModel)  -> SharedSequence<DriverSharingStrategy, TripType> in
//      let vc = self.viewController as! CreateTripViewController
//        return vc.viewModel.serverTripValidate(model: resultModel)
//          .asDriver(onErrorRecover: { (error) -> SharedSequence<DriverSharingStrategy, TripType> in
//            vc.validationErrorPopUp(error: error)
//            return Driver.just(TripType(id: 0, trip: String(), country: String(), imageURL: String()))
//          })
//      }.drive(onNext: {[weak self] (model) in
//        if model.id != 0 {
//          (self?.viewController as? CreateTripViewController)?.viewModel.dataSubject.onNext(.destination(model: model))
//        }
//      }).disposed(by: disposeBag)

    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      textField.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(16)
        make.top.equalTo(backButton.snp.bottom).offset(30)
        make.height.equalTo(46)
      }
      
      tableView.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview()
        make.top.equalTo(textField.snp.bottom)
      }
      
      backButton.snp.makeConstraints { (make) in
        make.left.equalTo(textField)
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(25)
        make.width.height.equalTo(40)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

extension SearchDestinationViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
}


