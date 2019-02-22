//
//  ProfileHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

class PHeaderView: UIView {
  
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  
  let datas = BehaviorRelay<[String]>(value: [])
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ProfileHeaderCell.self, forCellWithReuseIdentifier: String(describing: ProfileHeaderCell.self))
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    collectionView.isPagingEnabled = true
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<GenericSectionModel<String>>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileHeaderCell.self), for: idx) as! ProfileHeaderCell
    cell.item = item
    return cell
  })
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(collectionView)
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    datas.map{[GenericSectionModel<String>(items: $0)]}
      .asDriver(onErrorJustReturn: [])
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      collectionView.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview()
        make.height.equalTo(200)
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
  }
}

final class ProfileHeaderCell: UICollectionViewCell{
  var item: String?{
    didSet{
      guard let item = item else {return}
      profileImageView.kf.setImage(with: URL(string: item.addSumwhereImageURL()), options: [.transition(.fade(0.2))])
    }
  }
  private let profileImageView: UIImageView = {
    var imageView = UIImageView()
    imageView.kf.indicatorType = .activity
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(profileImageView)
    profileImageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
