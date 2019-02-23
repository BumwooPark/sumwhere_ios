//
//  StyleCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 23/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import UIKit

class StyleCell: UICollectionViewCell {
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .blue
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
