//
//  StyleCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 23/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import UIKit

class StyleCell: UICollectionViewCell {
  var didUpdateConstraint = false
  var item: TripStyle?{
    didSet{
      guard let item = item else {return}
      imageView.kf.setImage(with: URL(string: item.imageUrl.addSumwhereImageURL()), options: [.transition(.fade(0.2))])
    }
  }

  
  let imageView: UIImageView = {
    var imageView = UIImageView()
    imageView.kf.indicatorType = .activity
    imageView.backgroundColor = .blue
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      imageView.snp.makeConstraints { (make) in
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
