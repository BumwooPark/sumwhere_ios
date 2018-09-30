//
//  InterestViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 21..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import SnapKit
import RxCocoa
import RxDataSources

final class InterestViewController: UIViewController, ProfileCompletor{
  
  
  private let disposeBag = DisposeBag()
  private var didUpdateContraint = false
  weak var backSubject: PublishSubject<Void>?
  weak var viewModel: ProfileViewModel?
  weak var completeSubject: PublishSubject<Void>?
  private var constraint: Constraint?
  
  private var data = [TripStyleModel]()
  
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    return scrollView
  }()
  
  let contentView: UIView = {
    let view = UIView()
    return view
  }()


  private let titleLabel: UILabel = {
    let attributeString = NSMutableAttributedString(string: "당신의 여행스타일과\n그에 맞는 관심사를 선택해주세요\n",
                                                    attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 20),
                                                                 .foregroundColor: #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1) ])
    attributeString.append(NSAttributedString(string: "최소 세개까지 선택이 가능합니다.",
                                              attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 14),
                                                           .foregroundColor: #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)]))
    
    let label = UILabel()
    label.attributedText = attributeString
    label.numberOfLines = 3
    return label
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(TripStyleHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: TripStyleHeaderView.self))
    tableView.register(TripStyleCell.self, forCellReuseIdentifier: String(describing: TripStyleCell.self))
    tableView.separatorStyle = .none
    return tableView
  }()
  
  private let nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("다음", for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 21)
    button.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
    button.isEnabled = false
    return button
  }()
  
  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "backButton.png"), for: .normal)
    return button
  }()
  
  override func viewDidLoad(){
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(backButton)
    contentView.addSubview(titleLabel)
    contentView.addSubview(tableView)
    view.addSubview(nextButton)
    view.setNeedsUpdateConstraints()
    
    AuthManager.instance.provider
      .request(.GetAllTripStyle)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[TripStyleModel]>.self)
      .map{$0.result}
      .asObservable()
      .filterNil()
      .subscribeNext(weak: self, { (weakSelf) -> ([TripStyleModel]) -> Void in
        return {item in
          weakSelf.data = item
          weakSelf.tableView.reloadData()
        }
      }).disposed(by: disposeBag)
    
    
    
    guard let model = viewModel, let back = backSubject else {return}
    
    model
      .tripStyleAPI
      .subscribeNext(weak: self, { (weakSelf) -> ([TripStyleModel]) -> Void in
      return {item in
        weakSelf.data = item
        weakSelf.tableView.reloadData()
      }
    }).disposed(by: disposeBag)
    
    backButton.rx
      .tap
      .bind(to: back)
      .disposed(by: disposeBag)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let titleLabelHight = titleLabel.frame.height + 79 + 10
    constraint?.update(offset: tableView.contentSize.height + titleLabelHight)
  }
  
  override func updateViewConstraints() {
    if !didUpdateContraint{
      
      scrollView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      contentView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
        make.width.equalTo(self.view)
        constraint = make.height.equalTo(self.view).constraint
      }
      
      backButton.snp.makeConstraints { (make) in
        make.left.equalTo(self.view).inset(10)
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        make.width.height.equalTo(50)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(79)
        make.left.equalToSuperview().inset(36)
      }
      
      tableView.snp.makeConstraints { (make) in
        make.bottom.left.right.equalToSuperview()
        make.top.equalTo(titleLabel.snp.bottom).offset(10)
      }
      
      nextButton.snp.makeConstraints { (make) in
        make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        make.height.equalTo(61)
      }
      
      didUpdateContraint = true
    }
    super.updateViewConstraints()
  }
}


extension InterestViewController: UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].isOpend ? 1 : 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TripStyleCell.self), for: indexPath) as! TripStyleCell
    cell.item = data[indexPath.section].elements
    return cell
  }
}

extension InterestViewController: UITableViewDelegate{
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: TripStyleHeaderView.self)) as! TripStyleHeaderView
    view.item = data[section]
    
    view.contentView.rx
      .tapGesture()
      .when(.ended)
      .subscribeNext(weak: self) { (weakSelf) -> (UITapGestureRecognizer) -> Void in
        return {_ in
          weakSelf.data[section].isOpend = weakSelf.data[section].isOpend ? false : true
          weakSelf.tableView.reloadSections(IndexSet(integer: section), with: .fade)
        }
    }.disposed(by: view.disposeBag)
    
    return view
  }
  
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}
