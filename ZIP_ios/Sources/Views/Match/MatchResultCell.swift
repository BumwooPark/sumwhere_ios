//
//  ResultMatchCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 18..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class MatchResultCell: UICollectionViewCell{
  
  var item: UserTripJoinModel?{
    didSet{
//      profileImageView.kf.setImageWithZIP(image: item?.user.profile?.image1 ?? String())
//      nickNameLabel.text = item?.user.nickname
//      guard let birthday = item!.user.profile?.birthday.toDate() else {return}
//      ageLabel.text = "만\(Date().year - birthday.year)살"
    }
  }

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var cellBackView: UIView!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var destinationLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    profileImageView.backgroundColor = .blue
    profileImageView.layer.cornerRadius = 50
    profileImageView.layer.masksToBounds = true
    
    cellBackView.layer.cornerRadius = 10
    cellBackView.layer.shadowColor = UIColor.lightGray.cgColor
    cellBackView.layer.shadowOffset = CGSize(width: 2, height: 2)
    cellBackView.layer.shadowOpacity = 2
  }
}
