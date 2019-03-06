//
//  ProfileStyleCell.swift
//  ZIP_ios
//
//  Created by xiilab on 21/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

final class ProfileStyleCell: UICollectionViewCell{
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(StyleCell.self, forCellWithReuseIdentifier: String(describing: StyleCell.self))
    collectionView.register(StyleHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: StyleHeaderView.self))
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(collectionView)
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

