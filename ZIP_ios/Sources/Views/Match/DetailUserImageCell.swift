//
//  DetailUserViewCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 21..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//


class BaseDetailInfoCell: UICollectionViewCell{
  var item: UserTripJoinModel?
}

final class DetailUserImageCell: BaseDetailInfoCell{
  
  override var item: UserTripJoinModel?{
    didSet{
      profileImageView.kf.setImageWithZIP(image: item?.user.profile?.image1 ?? String())
      guard let startDate = (item?.trip.startDate ?? String()).toISODate()?.toFormat("yyyy-MM-dd"),
        let endDate = (item?.trip.endDate ?? String()).toISODate()?.toFormat("yyyy-MM-dd") else {return}
      dateLabel.text = "\(startDate) ~ \(endDate)"
    }
  }
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
