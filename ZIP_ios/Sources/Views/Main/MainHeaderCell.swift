//
//  MainHeaderCell.swift
//  ZIP_ios
//
//  Created by xiilab on 04/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//


class MainHeaderCell: UICollectionViewCell{
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOffset = CGSize(width: 6, height: 6)
    layer.shadowRadius = 10
    layer.shadowOpacity = 5
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
