//
//  DetailUserIntroduceCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 21..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class DetailUserIntroduceCell: BaseDetailInfoCell{
  
  override var item: UserTripJoinModel?{
    didSet{
      introduceTextView.text = item?.user.profile?.introText ?? String()
    }
  }
  
  @IBOutlet weak var introduceTextView: UITextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
