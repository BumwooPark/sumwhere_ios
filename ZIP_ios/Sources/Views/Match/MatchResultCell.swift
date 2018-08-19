//
//  ResultMatchCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 18..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class MatchResultCell: UICollectionViewCell{

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nickNameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    profileImageView.backgroundColor = .blue
    profileImageView.layer.cornerRadius = 50
  }
}
