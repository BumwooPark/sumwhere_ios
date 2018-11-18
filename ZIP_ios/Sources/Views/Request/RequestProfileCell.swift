//
//  RequestProfileCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 18/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit

final class RequestProfileCell: UICollectionViewCell{
  
  private var didUpdateConstraint = false
  let profileImageView: UIImageView = {
    let image = UIImageView()
    image.backgroundColor = .yellow
    image.layer.cornerRadius = 5
    image.layer.masksToBounds = true 
    return image
  }()
  
  let nicknameLabel: UILabel = {
    let label = UILabel()
    label.text = "테스트"
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(profileImageView)
    contentView.addSubview(nicknameLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      profileImageView.snp.makeConstraints { (make) in
        make.top.left.right.equalToSuperview()
        make.height.equalTo(77)
      }
      
      nicknameLabel.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview()
        make.top.equalTo(profileImageView.snp.bottom)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
