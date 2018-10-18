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
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.rowHeight = 50
//    tableView.separatorStyle = .none
    tableView.register(DestinationSearchCell.self, forCellReuseIdentifier: String(describing: DestinationSearchCell.self))
    return tableView
  }()
  
  lazy var dataSources = RxTableViewSectionedReloadDataSource<SearchDestTVModel>(configureCell: {[weak self] ds,tv,idx,item in
    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: DestinationSearchCell.self), for: idx) as! DestinationSearchCell
    cell.item = (item,self?.textField.text)
//    cell.selectionStyle = .none
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
    
    textField.rx
      .text
      .orEmpty
      .filterEmpty()
      .bind(to: viewModel.tripPlaceBinder)
      .disposed(by: disposeBag)
    
    viewModel.tripPlaceMapper
      .map{[SearchDestTVModel(items: $0)]}
      .bind(to: tableView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    
    textField.rx.controlEvent(.editingDidBegin)
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return { _ in
          weakSelf.textField.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(weakSelf.backButton.snp.right).offset(16)
            make.centerY.equalTo(weakSelf.backButton)
            make.height.equalTo(46)
          }
          
          UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {[weak self] in
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
            }, completion: nil)
        }
      }.disposed(by: disposeBag)
    
    textField.rx.controlEvent(.editingDidEnd)
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return { _ in
          weakSelf.textField.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(weakSelf.backButton.snp.bottom).offset(30)
            make.height.equalTo(46)
          }
          UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {[weak self] in
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
          }, completion: nil)
        }
      }.disposed(by: disposeBag)
    
    backButton
      .rx
      .tap
      .bind(to: viewModel.backAction)
      .disposed(by: disposeBag)
    
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
        make.left.equalToSuperview().inset(16)
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


