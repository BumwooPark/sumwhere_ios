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

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    hero.isEnabled = true
    imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
