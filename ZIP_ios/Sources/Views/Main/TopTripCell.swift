//
//  TopTripCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

final class TopTripCell: UICollectionViewCell{
  @IBOutlet weak var tripImageView: UIImageView!
  @IBOutlet weak var mainContentView: UIView!
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var charcterLabel: UILabel!
  @IBOutlet weak var tripTyleLabel: UILabel!
  
  @IBOutlet weak var addButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    mainContentView.layer.cornerRadius = 18
    mainContentView.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
    mainContentView.layer.shadowOffset = CGSize(width: 0, height: 2)
    mainContentView.layer.shadowOpacity = 4
  }
}
