//
//  DetailUserViewCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 21..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

protocol MatchDataSavable {
  var item: UserTripJoinModel? {get set}
}

final class DetailUserImageCell: UICollectionViewCell, MatchDataSavable{
  
  var item: UserTripJoinModel?{
    didSet{
      profileImageView.kf.setImageWithZIP(image: item?.user.profile?.image1 ?? String())
      
      let attributeString = NSMutableAttributedString(attributedString: NSAttributedString(string: "떠나는걸 좋아하는 여행자\n"))
      attributeString.append(NSAttributedString(string: "\"\(item?.user.nickname ?? String())\"", attributes: [.foregroundColor:#colorLiteral(red: 0.04194890708, green: 0.5622439384, blue: 0.8219085336, alpha: 1)]))
      attributeString.append(NSAttributedString(string: " 입니다."))
      titleLabel.attributedText = attributeString
    }
  }
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
