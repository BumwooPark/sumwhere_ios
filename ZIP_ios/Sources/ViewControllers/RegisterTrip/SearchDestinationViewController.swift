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
    textField.isEnabled = false
    return textField
  }()
  
  
  init(viewModel: RegisterTripViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  override func viewDidLoad() {
    
    view.addSubview(textField)
    view.addSubview(backButton)
    view.backgroundColor = .white
    hideKeyboardWhenTappedAround()
    
    textField.rx
      .text
      .orEmpty
      .ignore(String())
      .bind(to: viewModel.tripPlaceBinder)
      .disposed(by: disposeBag)
    
//    viewModel.tripPlaceMapper
//      .map{[SearchDestTVModel(items: $0)]}
//      .bind(to: tableView.rx.items(dataSource: dataSources))
//      .disposed(by: disposeBag)
    
    
//    textField.rx.controlEvent(.editingDidBegin)
//      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
//        return { _ in
//          weakSelf.textField.snp.remakeConstraints { (make) in
//            make.right.equalToSuperview().inset(16)
//            make.left.equalTo(weakSelf.backButton.snp.right).offset(16)
//            make.centerY.equalTo(weakSelf.backButton)
//            make.height.equalTo(46)
//          }
//          self.present(Init(UINavigationController(rootViewController:SampleViewController()), block: { (vc) in
//            vc.modalPresentationStyle = .overCurrentContext
//          }), animated: true, completion: nil)
//          UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {[weak self] in
//            self?.view.setNeedsLayout()
//            self?.view.layoutIfNeeded()
//            }, completion: nil)
//        }
//      }.disposed(by: disposeBag)
//
    textField.rx.tapGesture()
      .when(.ended)
      .subscribeNext(weak: self) { (weakSelf) -> (UITapGestureRecognizer) -> Void in
        return {_ in
          
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

//    backButton
//      .rx
//      .tap
//      .bind(to: viewModel.backAction)
//      .disposed(by: disposeBag)
    
    backButton
      .rx
      .tap
      .subscribeNext(weak: self) { (weakSelf) -> (Void) -> Void in
        return {_ in
          let sample = SampleViewController()
          sample.modalPresentationStyle = .overCurrentContext
          weakSelf.present(sample, animated: false, completion: nil)
        }
      }.disposed(by: disposeBag)
    
    
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      textField.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(16)
        make.top.equalTo(backButton.snp.bottom).offset(30)
        make.height.equalTo(46)
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

class SampleViewController: UIViewController {
  var didUpdateConstraint = false
  
  let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.showsCancelButton = true
    return searchBar
  }()
 
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.rowHeight = 50
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.register(DestinationSearchCell.self, forCellReuseIdentifier: String(describing: DestinationSearchCell.self))
    return tableView
  }()
  
  lazy var dataSources = RxTableViewSectionedReloadDataSource<SearchDestTVModel>(configureCell: {[weak self] ds,tv,idx,item in
    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: DestinationSearchCell.self), for: idx) as! DestinationSearchCell
//    cell.item = (item,self?.textField.text)
    //    cell.selectionStyle = .none
    return cell
  })
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    view.addSubview(tableView)
    view.addSubview(searchBar)
    view.setNeedsUpdateConstraints()
    definesPresentationContext = true
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint {
      
      searchBar.snp.makeConstraints { (make) in
        make.top.equalTo(self.view.safeAreaLayoutGuide)
        make.right.left.equalToSuperview()
        make.height.equalTo(54)
      }
      
      tableView.snp.makeConstraints { (make) in
        make.top.equalTo(searchBar.snp.bottom)
        make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
