//
//  RegisterdViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 25/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import AMScrollingNavbar

class RegisterdViewController: UIViewController{
  
  var didUpdateConstraint = false
  let model: TripModel
  let disposeBag = DisposeBag()
  let subView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  private let deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle("일정 삭제", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1), for: .normal)
    return button
  }()
  
  lazy var titleButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "locationIcon.png"), for: .normal)
    button.setTitle(model.tripType.trip, for: .normal)
    button.titleLabel?.font = UIFont.AppleSDGothicNeoMedium(size: 18)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  lazy var typeButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "scheduleMatchIcon.png"), for: .selected) // 계획
    button.setImage(#imageLiteral(resourceName: "onetimematchicon.png"), for: .normal) // 즉흥
    if self.model.trip.matchTypeId == 1{
      button.isSelected = false
    }else {
      button.isSelected = true
    }
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    return button
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 68, height: 413)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MatchResultCell.self, forCellWithReuseIdentifier: String(describing: MatchResultCell.self))
    collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
    collectionView.alwaysBounceVertical = true
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    return collectionView
  }()
  
  init(model: TripModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let navigationController = navigationController as? ScrollingNavigationController {
      navigationController.followScrollView(collectionView, delay: 50.0)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.backgroundColor = .white
    self.view.addSubview(subView)
    self.view.addSubview(collectionView)
    
    Observable.just(["","",""])
      .bind(to: collectionView.rx.items(cellIdentifier: String(describing: MatchResultCell.self), cellType: MatchResultCell.self)){
        idx,item,cell in
        
    }.disposed(by: disposeBag)
    
    navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: titleButton),UIBarButtonItem(customView: typeButton)]
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
    
    view.setNeedsUpdateConstraints()
  }
  
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      subView.snp.makeConstraints { (make) in
        make.top.equalTo((self.navigationController?.navigationBar.snp.bottom)!)
        make.left.right.equalToSuperview()
        make.height.equalTo(100)
      }
      
      collectionView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview()
        make.top.equalTo(subView.snp.bottom)
        make.bottom.equalTo(self.view.safeAreaLayoutGuide)
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
