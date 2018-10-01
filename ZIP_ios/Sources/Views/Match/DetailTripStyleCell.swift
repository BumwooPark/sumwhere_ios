//
//  DetailTripStyleCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class DetailTripStyleCell: UICollectionViewCell, MatchDataSavable{
  
  var item: UserTripJoinModel?{
    didSet{
    }
  }
  
  @IBOutlet weak var firstImageView: UIImageView!
  @IBOutlet weak var firstLabel: UILabel!
  
  @IBOutlet weak var secondImageView: UIImageView!
  @IBOutlet weak var secondLabel: UILabel!
  
  @IBOutlet weak var thridImageView: UIImageView!
  @IBOutlet weak var thirdLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
