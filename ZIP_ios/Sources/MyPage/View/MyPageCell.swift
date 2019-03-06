//
//  MyPageCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 11/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit

class MyPageCell: UICollectionViewCell{
  
  var didUpdateConstraint = false
  
  let rightButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "mypageButton.png"), for: .normal)
    button.isUserInteractionEnabled = false
    return button
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoSemiBold(size: 22)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleLabel)
    contentView.addSubview(rightButton)
    contentView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    
    if !didUpdateConstraint{
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(48)
        make.centerY.equalToSuperview()
      }
      rightButton.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(45)
        make.centerY.equalToSuperview()
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
