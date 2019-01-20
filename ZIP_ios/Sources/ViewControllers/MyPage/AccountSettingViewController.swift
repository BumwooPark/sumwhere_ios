//
//  AccountSettingViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 20/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift

class AccountSettingViewController: UIViewController{
  
  enum AccessType {
    case logout(title: String,action: () -> Void)
    case signout(title: String,action: () -> Void)
  }
  
  private let disposeBag = DisposeBag()
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(AccountSettingCell.self, forCellWithReuseIdentifier: String(describing: AccountSettingCell.self))
    collectionView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    title = "계정 설정"
    
    Observable.just([
      AccessType.logout(title: "로그아웃", action: {
        tokenObserver.accept(String())
    }),AccessType.signout(title: "회원 탈퇴", action: {
      
    })]).bind(to: collectionView.rx.items(cellIdentifier: String(describing: AccountSettingCell.self),
                                          cellType: AccountSettingCell.self)){
                                            idx,item,cell in
      cell.item = item
    }.disposed(by: disposeBag)
    
    
    collectionView.rx.modelSelected(AccessType.self)
      .subscribeNext(weak: self) { (weakSelf) -> (AccountSettingViewController.AccessType) -> Void in
        return {item in
          switch item {
          case .logout(_,let action),.signout(_,let action):
            action()
          }
        }
    }.disposed(by: disposeBag)
    
  }
}

class AccountSettingCell: UICollectionViewCell{
  private var updateConstraint = false
  
  var item: AccountSettingViewController.AccessType?{
    didSet{
      guard let item = item else {return}
      switch item {
      case .logout(let title, _),.signout(let title, _):
        log.info(title)
        titleLabel.text = title
      }
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoRegular(size: 19)
    label.textColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
    return label
  }()
  
  private let pushButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "mypageButton.png"), for: .normal)
    return button
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleLabel)
    contentView.addSubview(pushButton)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !updateConstraint{
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(33)
        make.centerY.equalToSuperview()
      }
      
      pushButton.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(33)
        make.centerY.equalToSuperview()
      }
      
      
      updateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
