//
//  TopTripCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

final class TopTripCell: UICollectionViewCell{
  @IBOutlet weak var tripImageView: UIImageView!
  @IBOutlet weak var tripNameLabel: UILabel!
  @IBOutlet weak var countryLabel: TopTripLabel!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var commitButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    countryLabel.layer.cornerRadius = 10
    countryLabel.clipsToBounds = true
    commitButton.layer.cornerRadius = 10
    commitButton.clipsToBounds = true 
  }
}

class TopTripLabel: UILabel {
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)))
  }
  
  override var intrinsicContentSize: CGSize{
    var size = super.intrinsicContentSize
    size.width += 20
    size.height += 10
    return size
  }
}
