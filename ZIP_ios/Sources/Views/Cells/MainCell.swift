//
//  MainCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 2. 15..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import UIKit
import Kingfisher


class MainCell: UICollectionViewCell{
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .lightGray
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 5
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "샘플입니다"
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    addConstraint()
  }
  
  
  private func addConstraint(){
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(5)
      make.left.equalToSuperview().inset(5)
    }
    
    imageView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(5)
      make.left.equalToSuperview().inset(5)
      make.right.equalToSuperview().inset(5)
      make.height.equalTo(imageView.snp.width)
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
