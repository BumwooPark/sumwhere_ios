//
//  MainViewCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import expanding_collection

class MainViewCell: BasePageCollectionCell{
  var item: TripType? {
    didSet{
      titleLabel.text = item?.destination
      imageView.kf.setImageWithZIP(image: item?.imageURL ?? String())
    }
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let coverLayer = CALayer()
    coverLayer.frame = imageView.bounds
    coverLayer.backgroundColor = UIColor.black.cgColor
    coverLayer.opacity = 0.5
    imageView.layer.addSublayer(coverLayer)
  }
}
