//
//  MatchHeaderView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 31..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Hero

class MatchHeaderView: UICollectionReusableView{
  
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true 
    return imageView
  }()

  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.BMJUA(size: 30)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    imageView.addSubview(titleLabel)
    hero.isEnabled = true
    imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
