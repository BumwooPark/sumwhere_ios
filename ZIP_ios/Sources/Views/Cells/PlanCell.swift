//
//  PlanCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 25..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import Kingfisher

class PlanCell: UICollectionViewCell{
  
  static let ID = "PlanCell"
  
  var model: PlanModel?{
    didSet{
      guard let model = model else {return}
      titleLabel.text = model.title
      imageView.kf.setImage(with: model.imageURL)
      likeCount.text = "\(model.like)"
    }
  }
  
  let titleLabel = UILabel()
  let imageView = UIImageView()
  let likeCount = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.backgroundColor = .white
    contentView.addSubview(titleLabel)
    contentView.addSubview(imageView)
    contentView.layer.cornerRadius = 10
    contentView.layer.shadowColor = UIColor.gray.cgColor
    contentView.layer.shadowOffset = CGSize(width: 2, height: 4)
    contentView.layer.shadowOpacity = 1
    
    addConstraint()
  }
  
  private func addConstraint(){
    imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(10)
      make.left.equalToSuperview().inset(10)
    }
    
    likeCount.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().inset(10)
      make.left.equalToSuperview().inset(10)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
