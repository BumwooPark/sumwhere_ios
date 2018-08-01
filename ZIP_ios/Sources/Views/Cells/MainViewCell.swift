//
//  MainViewCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import expanding_collection

class MainViewCell: BasePageCollectionCell{
  var item: TripModel? {
    didSet{
      titleLabel.text = item?.tripType.destination
      imageView.kf.setImageWithZIP(image: item?.tripType.imageURL ?? String())
      guard let startAt = item?.trip.startDate,let endAt = item?.trip.endDate else {return}
      startLabel.text = String(startAt.prefix(10))
      endLabel.text = String(endAt.prefix(10))
    }
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var startLabel: UILabel!
  @IBOutlet weak var endLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let coverLayer = CALayer()
    coverLayer.frame = imageView.bounds
    coverLayer.backgroundColor = UIColor.black.cgColor
    coverLayer.opacity = 0.5
    imageView.layer.addSublayer(coverLayer)
  }
}
