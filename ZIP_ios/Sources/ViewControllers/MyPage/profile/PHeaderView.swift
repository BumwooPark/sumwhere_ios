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

class PHeaderView: UIView {
  
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 180, height: 180)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ProfileHeaderCell.self, forCellWithReuseIdentifier: String(describing: ProfileHeaderCell.self))
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(collectionView)
    
    Observable.just([1,2,3]).bind(to: collectionView.rx.items(cellIdentifier: String(describing: ProfileHeaderCell.self), cellType: ProfileHeaderCell.self)){index, model, cell in
      
      }.disposed(by: disposeBag)
    
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


final class ProfileHeaderCell: UICollectionViewCell{
  
  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 20
    imageView.layer.masksToBounds = true
    imageView.backgroundColor = .blue
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
