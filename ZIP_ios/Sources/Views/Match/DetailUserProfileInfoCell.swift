//
//  DetailUserProfileInfoCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 21..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

final class DetailUserProfileInfoCell: BaseDetailInfoCell{
  
  override var item: UserTripJoinModel?{
    didSet{
      nickNameLabel.text = item?.user.nickname
      guard let birthday = item?.user.profile?.birthday.toISODate() else {return}
      ageLabel.text = "만\(Date().year - birthday.year)세"
    }
  }
  
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var tripStyleLabel: UILabel!
  @IBOutlet weak var characterLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
