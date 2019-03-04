//
//  MainHeaderView.swift
//  ZIP_ios
//
//  Created by xiilab on 04/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

class MainHeaderView: UIView{
  
  let disposeBag = DisposeBag()
  private var didUpdateConstraint = false
  let bgImage: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "bgAd.png"))
    return imageView
  }()
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 17
    layout.minimumLineSpacing = 17
    layout.itemSize = CGSize(width: 312, height: 312)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MainHeaderCell.self, forCellWithReuseIdentifier: String(describing: MainHeaderCell.self))
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(bgImage)
    addSubview(collectionView)
    
    Observable.just([1,2,3])
      .bind(to: collectionView.rx.items(cellIdentifier: String(describing: MainHeaderCell.self), cellType: MainHeaderCell.self)){
        dd,cell,idx in
      }.disposed(by: disposeBag)
    
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      bgImage.snp.makeConstraints { (make) in
        make.left.right.top.equalToSuperview()
        make.height.equalTo(340)
      }
      
      collectionView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


